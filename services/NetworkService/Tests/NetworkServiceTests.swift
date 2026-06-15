//
//  NetworkServiceTests.swift
//  NetworkServiceTests
//
//  Created by Sergio Acosta on 12/06/26.
//

import XCTest
@testable import NetworkService

final class NetworkServiceTests: XCTestCase {
    private var urlCache: URLCache!
    private var session: URLSession!
    private var service: NetworkService!

    override func setUp() {
        super.setUp()
        MockURLProtocol.removeAllStubs()
        urlCache = URLCache(
            memoryCapacity: 1024 * 1024,
            diskCapacity: 0,
            diskPath: nil
        )

        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [MockURLProtocol.self]
        configuration.urlCache = urlCache
        session = URLSession(configuration: configuration)
        service = NetworkService(session: session)
    }

    override func tearDown() {
        urlCache.removeAllCachedResponses()
        MockURLProtocol.removeAllStubs()
        service = nil
        session = nil
        urlCache = nil
        super.tearDown()
    }

    func testFetchListEndpointBuildsExpectedURL() {
        let endpoint = Endpoint.fetchList(page: 2)

        XCTAssertEqual(endpoint.url?.absoluteString, "https://api.disneyapi.dev/character?page=2")
        XCTAssertEqual(endpoint.method, .get)
        XCTAssertEqual(endpoint.headers["Content-Type"], "application/json")
        XCTAssertNil(endpoint.body)
        XCTAssertEqual(endpoint.cachePolicy, .useProtocolCachePolicy)
    }

    func testFetchDetailEndpointBuildsExpectedURL() {
        let endpoint = Endpoint.fetchDetail(id: "117")

        XCTAssertEqual(endpoint.url?.absoluteString, "https://api.disneyapi.dev/character/117")
        XCTAssertEqual(endpoint.method, .get)
        XCTAssertNil(endpoint.body)
    }

    func testExecuteDecodesSuccessfulResponse() async throws {
        let endpoint = Endpoint.fetchDetail(id: "117")
        MockURLProtocol.stub(
            endpoint.url,
            statusCode: 200,
            data: #"{"id":117,"name":"Pegasus"}"#.data(using: .utf8)
        )

        let response: CharacterResponse = try await service.execute(endpoint)

        XCTAssertEqual(response.id, 117)
        XCTAssertEqual(response.name, "Pegasus")
    }

    func testExecuteStoresAndReturnsCachedResponse() async throws {
        let endpoint = Endpoint.fetchDetail(id: "cache-\(UUID().uuidString)")
        MockURLProtocol.stub(
            endpoint.url,
            statusCode: 200,
            data: #"{"id":999,"name":"Cached Pegasus"}"#.data(using: .utf8)
        )

        let firstResponse: CharacterResponse = try await service.execute(endpoint)
        XCTAssertNotNil(cachedResponse(for: endpoint))

        MockURLProtocol.removeAllStubs()
        let cachedResponse: CharacterResponse = try await service.execute(endpoint)

        XCTAssertEqual(firstResponse, cachedResponse)
    }

    func testExecuteThrowsInvalidResponseForNonSuccessfulStatusCode() async {
        let endpoint = Endpoint.fetchDetail(id: "server-error-\(UUID().uuidString)")
        MockURLProtocol.stub(
            endpoint.url,
            statusCode: 500,
            data: #"{"message":"Server error"}"#.data(using: .utf8)
        )

        await XCTAssertThrowsErrorAsync({
            try await service.execute(endpoint) as CharacterResponse
        }) { error in
            guard case NetworkError.invalidResponse = error else {
                XCTFail("Expected invalidResponse error, got \(error).")
                return
            }
        }
    }

    func testExecuteThrowsDecodingErrorForInvalidPayload() async {
        let endpoint = Endpoint.fetchDetail(id: "invalid-payload-\(UUID().uuidString)")
        MockURLProtocol.stub(
            endpoint.url,
            statusCode: 200,
            data: #"{"id":"invalid"}"#.data(using: .utf8)
        )

        await XCTAssertThrowsErrorAsync({
            try await service.execute(endpoint) as CharacterResponse
        }) { error in
            XCTAssertTrue(error is DecodingError)
        }
    }
}

private extension NetworkServiceTests {
    func cachedResponse(for endpoint: Endpoint) -> CachedURLResponse? {
        guard let url = endpoint.url else { return nil }

        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        request.httpBody = endpoint.body
        request.cachePolicy = endpoint.cachePolicy
        endpoint.headers.forEach { key, value in
            request.setValue(value, forHTTPHeaderField: key)
        }

        return urlCache.cachedResponse(for: request)
    }
}

private struct CharacterResponse: Decodable, Equatable {
    let id: Int
    let name: String
}

private final class MockURLProtocol: URLProtocol {
    private struct Stub {
        let statusCode: Int
        let data: Data
        let headers: [String: String]
    }

    private static var stubs: [URL: Stub] = [:]
    private(set) static var requestCount = 0

    override class func canInit(with request: URLRequest) -> Bool {
        true
    }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        request
    }

    override func startLoading() {
        Self.requestCount += 1

        guard let url = request.url, let stub = Self.stubs[url] else {
            client?.urlProtocol(self, didFailWithError: URLError(.badURL))
            return
        }

        let response = HTTPURLResponse(
            url: url,
            statusCode: stub.statusCode,
            httpVersion: nil,
            headerFields: stub.headers
        )!

        client?.urlProtocol(
            self,
            didReceive: response,
            cacheStoragePolicy: .allowed
        )
        client?.urlProtocol(self, didLoad: stub.data)
        client?.urlProtocolDidFinishLoading(self)
    }

    override func stopLoading() { }

    static func stub(
        _ url: URL?,
        statusCode: Int,
        data: Data?,
        headers: [String: String] = ["Content-Type": "application/json"]
    ) {
        guard let url, let data else {
            XCTFail("A valid URL and data are required to create a stub.")
            return
        }

        stubs[url] = Stub(
            statusCode: statusCode,
            data: data,
            headers: headers
        )
    }

    static func removeAllStubs() {
        stubs.removeAll()
        requestCount = 0
    }
}

private func XCTAssertThrowsErrorAsync<T>(
    _ expression: () async throws -> T,
    _ validation: (Error) -> Void,
    file: StaticString = #filePath,
    line: UInt = #line
) async {
    do {
        _ = try await expression()
        XCTFail("Expected expression to throw an error.", file: file, line: line)
    } catch {
        validation(error)
    }
}
