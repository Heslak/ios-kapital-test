//
//  CharacterInfo+Extensions.swift
//  KapitalTest
//
//  Created by Sergio Acosta on 15/06/26.
//

import DesignSystem

extension CharacterInfo {
    func settingFavorite(_ isFavorite: Bool) -> CharacterInfo {
        CharacterInfo(
            id: id,
            films: films,
            shortFilms: shortFilms,
            tvShows: tvShows,
            videoGames: videoGames,
            parkAttractions: parkAttractions,
            allies: allies,
            enemies: enemies,
            name: name,
            imageUrl: imageUrl,
            url: url,
            isFavorite: isFavorite
        )
    }
    
    func getTags() -> [CharacterTagViewType] {
        var tags: [CharacterTagViewType] = []
        
        if films.count > 0 || shortFilms.count > 0 { tags.append(.film(count: films.count + shortFilms.count)) }
        if tvShows.count > 0 { tags.append(.show(count: tvShows.count)) }
        if videoGames.count > 0 { tags.append(.game(count: videoGames.count)) }
        if parkAttractions.count > 0 { tags.append(.attractions(count: parkAttractions.count)) }
        
        return tags
    }
    
    var placeholderColor: DSColorStyle.PlaceholderStyle {
        let colors: [DSColorStyle.PlaceholderStyle] = [
            .cyan,
            .yellow,
            .green,
            .pink,
            .purple
        ]
        
        return colors[abs(self.id - 1) % colors.count]
    }
    
    var totalCountStats: Int {
        films.count +
        shortFilms.count +
        tvShows.count +
        videoGames.count +
        parkAttractions.count
    }
    
    func getStats() -> [CharacterDetailStatModel] {
        return [
            .init(
                iconName: "film",
                title: AppStrings.filmsTitle,
                count: films.count + shortFilms.count,
                color: .ink(.film)
            ),
            .init(
                iconName: "tv",
                title: AppStrings.showsTitle,
                count: tvShows.count,
                color: .ink(.show)
            ),
            .init(
                iconName: "gamecontroller",
                title: AppStrings.gamesTitle,
                count: videoGames.count,
                color: .ink(.game)
            ),
            .init(
                iconName: "sparkles",
                title: AppStrings.totalTitle,
                count: totalCountStats,
                color: .ink(.enemies)
            )
        ]
    }
    
    func getStatsSection() -> [CharacterDetailSectionModel] {
        return [
            .init(
                iconName: "film",
                title: AppStrings.filmsTitle,
                items: films,
                emptyMessage: AppStrings.noFilmsMessage,
                color: .ink(.film),
                background: .placeholder(.blue)
            ),
            .init(
                iconName: "tv",
                title: AppStrings.tvShowsTitle,
                items: tvShows,
                emptyMessage: AppStrings.noTVShowsMessage,
                color: .ink(.show),
                background: .placeholder(.orange)
            ),
            .init(
                iconName: "gamecontroller",
                title: AppStrings.videoGamesTitle,
                items: videoGames,
                emptyMessage: AppStrings.noVideoGamesMessage,
                color: .ink(.game),
                background: .placeholder(.green)
            ),
            .init(
                iconName: "mappin.circle",
                title: AppStrings.parkAttractionsTitle,
                items: parkAttractions,
                emptyMessage: AppStrings.noParkAttractionsMessage,
                color: .ink(.attraction),
                background: .placeholder(.pink)
            ),
            .init(
                iconName: "person.2",
                title: AppStrings.alliesTitle,
                items: allies,
                emptyMessage: AppStrings.noAlliesMessage,
                color: .ink(.allies),
                background: .placeholder(.cyan)
            ),
            .init(
                iconName: "bolt",
                title: AppStrings.enemiesTitle,
                items: enemies,
                emptyMessage: AppStrings.noEnemiesMessage,
                color: .ink(.enemies),
                background: .placeholder(.pink)
            )
        ]
    }
}
