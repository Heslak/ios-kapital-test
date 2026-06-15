//
//  ViewState.swift
//  KapitalTest
//
//  Created by Sergio Acosta on 15/06/26.
//

import Foundation

// MARK: - View State

/// Represents the loading state of a screen or component.
/// Used across all ViewModels to maintain consistent state management.
enum ViewState: Equatable {
    /// Initial state before any load attempt.
    case shouldLoad
    
    /// Currently fetching data.
    case loading
    
    /// Data successfully loaded and ready to display.
    case loaded
    
    /// An error occurred during the last load attempt.
    case error
}
