//
//  DSImageLoader.swift
//  Pods
//
//  Created by Sergio Acosta on 15/06/26.
//

import Foundation
import ImageIO
import UIKit

public protocol DSImageLoading {
    func loadImage(
        from url: URL,
        targetSize: CGSize,
        scale: CGFloat
    ) async throws -> UIImage
}

public actor DSImageLoader: DSImageLoading {
    public static let shared = DSImageLoader()
    
    private let cache = NSCache<NSString, UIImage>()
    private var runningTasks: [String: Task<UIImage, Error>] = [:]
    
    public init(cacheLimit: Int = 200) {
        cache.countLimit = cacheLimit
    }
    
    public func loadImage(
        from url: URL,
        targetSize: CGSize,
        scale: CGFloat
    ) async throws -> UIImage {
        let cacheKey = makeCacheKey(
            url: url,
            targetSize: targetSize,
            scale: scale
        )
        
        if let image = cachedImage(for: cacheKey) {
            return image
        }
        
        if let image = try await imageFromRunningTask(for: cacheKey) {
            return image
        }
        
        let pixelSize = max(targetSize.width, targetSize.height) * scale
        
        return try await loadAndCacheImage(
            from: url,
            cacheKey: cacheKey,
            pixelSize: pixelSize
        )
    }
    
    public func cancelAllTasks() {
        runningTasks.values.forEach { task in
            task.cancel()
        }
        
        runningTasks.removeAll()
    }
    
    private func cachedImage(for cacheKey: String) -> UIImage? {
        cache.object(forKey: cacheKey as NSString)
    }
    
    private func imageFromRunningTask(for cacheKey: String) async throws -> UIImage? {
        guard let runningTask = runningTasks[cacheKey] else {
            return nil
        }
        
        return try await runningTask.value
    }
    
    private func loadAndCacheImage(
        from url: URL,
        cacheKey: String,
        pixelSize: CGFloat
    ) async throws -> UIImage {
        let task = Task<UIImage, Error> {
            let (data, _) = try await URLSession.shared.data(from: url)
            
            return try await Self.downsampleImage(
                from: data,
                pixelSize: pixelSize
            )
        }
        
        runningTasks[cacheKey] = task
        defer { runningTasks[cacheKey] = nil }
        
        let image = try await task.value
        let cost = image.memoryCost
        
        cache.setObject(
            image,
            forKey: cacheKey as NSString,
            cost: cost
        )
        
        return image
    }
    
    private func makeCacheKey(
        url: URL,
        targetSize: CGSize,
        scale: CGFloat
    ) -> String {
        let width = Int(targetSize.width * scale)
        let height = Int(targetSize.height * scale)
        
        return "\(url.absoluteString)-\(width)x\(height)"
    }
    
    private static func downsampleImage(
        from data: Data,
        pixelSize: CGFloat
    ) async throws -> UIImage {
        try await Task.detached(priority: .utility) {
            guard let source = CGImageSourceCreateWithData(data as CFData, nil) else {
                throw DSImageLoaderError.invalidData
            }
            
            let options = [
                kCGImageSourceCreateThumbnailFromImageAlways: true,
                kCGImageSourceShouldCacheImmediately: true,
                kCGImageSourceCreateThumbnailWithTransform: true,
                kCGImageSourceThumbnailMaxPixelSize: max(1, Int(pixelSize))
            ] as CFDictionary
            
            guard let image = CGImageSourceCreateThumbnailAtIndex(source, 0, options) else {
                throw DSImageLoaderError.invalidData
            }
            
            return UIImage(cgImage: image)
        }.value
    }
}

public enum DSImageLoaderError: Error {
    case invalidData
}

private extension UIImage {
    var memoryCost: Int {
        guard let cgImage else {
            return 0
        }
        
        return cgImage.bytesPerRow * cgImage.height
    }
}
