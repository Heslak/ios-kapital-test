//
//  CharactersList.swift
//  KapitalTest
//
//  Created by Sergio Acosta on 12/06/26.
//

import Foundation
import LocalStorageService

struct CharactersList: Decodable, LocalStorableCharactersList {
    let info: ListInfo
    let data: [CharacterInfo]
}

struct CharacterDetail: Decodable {
    let data: CharacterInfo
}

struct CharacterInfo: Decodable, LocalStorableCharacterInfo {
    let id: Int
    let films: [String]
    let shortFilms: [String]
    let tvShows: [String]
    let videoGames: [String]
    let parkAttractions: [String]
    let allies: [String]
    let enemies: [String]
    let name: String
    let imageUrl: String?
    let url: String
    let isFavorite: Bool
    
    init(
        id: Int,
        films: [String],
        shortFilms: [String],
        tvShows: [String],
        videoGames: [String],
        parkAttractions: [String],
        allies: [String],
        enemies: [String],
        name: String,
        imageUrl: String?,
        url: String,
        isFavorite: Bool = false
    ) {
        self.id = id
        self.films = films
        self.shortFilms = shortFilms
        self.tvShows = tvShows
        self.videoGames = videoGames
        self.parkAttractions = parkAttractions
        self.allies = allies
        self.enemies = enemies
        self.name = name
        self.imageUrl = imageUrl
        self.url = url
        self.isFavorite = isFavorite
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case films
        case shortFilms
        case tvShows
        case videoGames
        case parkAttractions
        case allies
        case enemies
        case name
        case imageUrl
        case url
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.id = try container.decode(Int.self, forKey: .id)
        self.films = try container.decode([String].self, forKey: .films)
        self.shortFilms = try container.decode([String].self, forKey: .shortFilms)
        self.tvShows = try container.decode([String].self, forKey: .tvShows)
        self.videoGames = try container.decode([String].self, forKey: .videoGames)
        self.parkAttractions = try container.decode([String].self, forKey: .parkAttractions)
        self.allies = try container.decode([String].self, forKey: .allies)
        self.enemies = try container.decode([String].self, forKey: .enemies)
        self.name = try container.decode(String.self, forKey: .name)
        self.imageUrl = try container.decodeIfPresent(String.self, forKey: .imageUrl)
        self.url = try container.decode(String.self, forKey: .url)
        self.isFavorite = false
    }
}

struct ListInfo: Decodable, LocalStorableListInfo {
    let count: Int
    let totalPages: Int
    let previousPage: String?
    let nextPage: String
}
