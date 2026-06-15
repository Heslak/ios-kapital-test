//
//  AccessibilityIdentifiers.swift
//  KapitalTest
//
//  Created by Sergio Acosta on 15/06/26.
//

import Foundation

// MARK: - Accessibility Identifiers

/// Centralized accessibility identifiers for UI testing and VoiceOver support.
/// Each screen and component has its own namespace to avoid conflicts.
enum AccessibilityIdentifiers {
    
    // MARK: - Home Screen
    
    enum Home {
        static let screenTitle = "home_screen_title"
        static let charactersList = "home_characters_list"
        static let loadingIndicator = "home_loading_indicator"
        static let errorView = "home_error_view"
        static let retryButton = "home_retry_button"
        
        enum CharacterCell {
            static func cell(id: Int) -> String {
                "home_character_cell_\(id)"
            }
            
            static func name(id: Int) -> String {
                "home_character_name_\(id)"
            }
            
            static func avatar(id: Int) -> String {
                "home_character_avatar_\(id)"
            }
            
            static func favoriteButton(id: Int) -> String {
                "home_character_favorite_\(id)"
            }
        }
    }
    
    // MARK: - Character Detail Screen
    
    enum CharacterDetail {
        static let screenTitle = "detail_screen_title"
        static let backButton = "detail_back_button"
        static let favoriteButton = "detail_favorite_button"
        static let headerImage = "detail_header_image"
        static let characterName = "detail_character_name"
        static let statsContainer = "detail_stats_container"
        static let tagsContainer = "detail_tags_container"
        static let sectionsContainer = "detail_sections_container"
        static let loadingIndicator = "detail_loading_indicator"
        static let errorView = "detail_error_view"
        
        enum Stats {
            static let filmsCount = "detail_stats_films"
            static let showsCount = "detail_stats_shows"
            static let gamesCount = "detail_stats_games"
            static let totalCount = "detail_stats_total"
        }
        
        enum Section {
            static func header(_ name: String) -> String {
                "detail_section_header_\(name.lowercased())"
            }
            
            static func content(_ name: String) -> String {
                "detail_section_content_\(name.lowercased())"
            }
        }
    }
    
    // MARK: - Favorites Screen
    
    enum Favorites {
        static let screenTitle = "favorites_screen_title"
        static let charactersList = "favorites_characters_list"
        static let emptyView = "favorites_empty_view"
        static let emptyTitle = "favorites_empty_title"
        static let emptyDescription = "favorites_empty_description"
        static let errorView = "favorites_error_view"
        
        enum CharacterCell {
            static func cell(id: Int) -> String {
                "favorites_character_cell_\(id)"
            }
            
            static func favoriteButton(id: Int) -> String {
                "favorites_character_favorite_\(id)"
            }
        }
    }
    
    // MARK: - Main Tab Bar
    
    enum TabBar {
        static let container = "tab_bar_container"
        static let homeTab = "tab_bar_home"
        static let favoritesTab = "tab_bar_favorites"
    }
    
    // MARK: - Common Components
    
    enum Common {
        static let loadingView = "common_loading_view"
        static let errorView = "common_error_view"
        static let retryButton = "common_retry_button"
    }
}

// MARK: - Accessibility Labels

/// Centralized accessibility labels for VoiceOver descriptions.
/// Provides meaningful descriptions for users with visual impairments.
enum AccessibilityLabels {
    
    enum Home {
        static func characterCell(name: String, isFavorite: Bool) -> String {
            let favoriteStatus = isFavorite ? "Favorite" : "Not favorite"
            return "\(name), Disney character. \(favoriteStatus). Double tap to see details."
        }
        
        static func favoriteButton(name: String, isFavorite: Bool) -> String {
            isFavorite
                ? "Remove \(name) from favorites"
                : "Add \(name) to favorites"
        }
    }
    
    enum CharacterDetail {
        static func header(name: String) -> String {
            "Character detail for \(name)"
        }
        
        static func stats(films: Int, shows: Int, games: Int) -> String {
            "Appears in \(films) films, \(shows) TV shows, and \(games) video games"
        }
        
        static func favoriteButton(isFavorite: Bool) -> String {
            isFavorite
                ? "Remove from favorites"
                : "Add to favorites"
        }
        
        static let backButton = "Go back to characters list"
    }
    
    enum Favorites {
        static let emptyState = "No favorite characters yet. Add characters from the home screen."
    }
    
    enum Common {
        static let loading = "Loading content, please wait"
        static let error = "An error occurred. Tap retry to try again."
        static let retryButton = "Retry loading"
    }
}

// MARK: - Accessibility Hints

/// Accessibility hints provide additional context about what actions will do.
enum AccessibilityHints {
    
    enum CharacterCell {
        static let tap = "Opens character detail screen"
        static let favorite = "Toggles favorite status"
    }
    
    enum Navigation {
        static let back = "Returns to previous screen"
    }
    
    enum TabBar {
        static let home = "Shows all Disney characters"
        static let favorites = "Shows your favorite characters"
    }
}
