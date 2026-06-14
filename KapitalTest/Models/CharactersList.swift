//
//  CharactersList.swift
//  KapitalTest
//
//  Created by Sergio Acosta on 12/06/26.
//

import Foundation

struct CharactersList: Decodable {
    let info: ListInfo
    let data: [CharacterInfo]
}

struct CharacterInfo: Decodable {
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
}

struct ListInfo: Decodable {
    let count: Int
    let totalPages: Int
    let previousPage: String?
    let nextPage: String
}
