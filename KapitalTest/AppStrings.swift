//
//  AppStrings.swift
//  KapitalTest
//
//  Created by Sergio Acosta on 15/06/26.
//

import Foundation

enum AppStrings {
    static let appEyebrow = localized("app.eyebrow")
    static let charactersTitle = localized("characters.title")
    static let favoritesTitle = localized("favorites.title")
    static let allCharactersTitle = localized("home.allCharacters.title")
    static let errorTitle = localized("state.error.title")
    static let retryButton = localized("action.retry")
    static let loadingTitle = localized("state.loading")
    static let favoriteAccessibilityLabel = localized("accessibility.favorite")
    static let disneyCharacterTitle = localized("character.kind.disney")
    
    static let noFavoritesTitle = localized("favorites.empty.title")
    static let noFavoritesDescription = localized("favorites.empty.description")
    
    static let filmsTitle = localized("detail.stats.films")
    static let showsTitle = localized("detail.stats.shows")
    static let gamesTitle = localized("detail.stats.games")
    static let totalTitle = localized("detail.stats.total")
    
    static let tvShowsTitle = localized("detail.section.tvShows")
    static let videoGamesTitle = localized("detail.section.videoGames")
    static let parkAttractionsTitle = localized("detail.section.parkAttractions")
    static let alliesTitle = localized("detail.section.allies")
    static let enemiesTitle = localized("detail.section.enemies")
    
    static let noFilmsMessage = localized("detail.empty.films")
    static let noTVShowsMessage = localized("detail.empty.tvShows")
    static let noVideoGamesMessage = localized("detail.empty.videoGames")
    static let noParkAttractionsMessage = localized("detail.empty.parkAttractions")
    static let noAlliesMessage = localized("detail.empty.allies")
    static let noEnemiesMessage = localized("detail.empty.enemies")
    
    static let featureFilmTag = localized("character.tag.featureFilm")
    static let tvSeriesTag = localized("character.tag.tvSeries")
    static let videoGameTag = localized("character.tag.videoGame")
    static let parkAttractionTag = localized("character.tag.parkAttraction")
    
    static func filmCount(_ count: Int) -> String {
        localizedPlural("character.tag.film.count", count: count)
    }
    
    static func showCount(_ count: Int) -> String {
        localizedPlural("character.tag.show.count", count: count)
    }
    
    static func gameCount(_ count: Int) -> String {
        localizedPlural("character.tag.game.count", count: count)
    }
    
    static func attractionCount(_ count: Int) -> String {
        localizedPlural("character.tag.attraction.count", count: count)
    }
    
    private static func localized(_ key: String) -> String {
        NSLocalizedString(
            key,
            tableName: "Localizable",
            bundle: .main,
            value: key,
            comment: ""
        )
    }
    
    private static func localizedPlural(_ key: String, count: Int) -> String {
        let format = localized(key)
        return String.localizedStringWithFormat(format, count)
    }
}
