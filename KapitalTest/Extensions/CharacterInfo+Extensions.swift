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
        
        if films.count > 0 ||  shortFilms.count > 0 { tags.append(.film(count: films.count + shortFilms.count)) }
        if tvShows.count > 0 { tags.append(.show(count: tvShows.count)) }
        if videoGames.count > 0 { tags.append(.game(count: videoGames.count)) }
        if parkAttractions.count > 0 { tags.append(.attractions(count: parkAttractions.count)) }
        
        return tags
    }
    
    func placeholderColor() -> DSColorStyle.PlaceholderStyle {
        let colors: [DSColorStyle.PlaceholderStyle] = [
            .cyan,
            .yellow,
            .green,
            .pink,
            .purple
        ]
        
        return colors[abs(self.id - 1) % colors.count]
    }
}
