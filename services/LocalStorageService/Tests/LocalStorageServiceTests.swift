//
//  LocalStorageServiceTests.swift
//  LocalStorageServiceTests
//
//  Created by Sergio Acosta on 15/06/26.
//

import CoreData
import XCTest
@testable import LocalStorageService

final class LocalStorageServiceTests: XCTestCase {
    private var service: LocalStorageService!

    override func setUp() {
        super.setUp()
        let stack = LocalStorageCoreDataStack(storeType: NSInMemoryStoreType)
        service = LocalStorageService(coreDataStack: stack)
    }

    override func tearDown() {
        service = nil
        super.tearDown()
    }

    func testSaveCharactersListAndGetCharactersListReturnsPersistedDataInOrder() throws {
        let list = TestCharactersList(
            info: .init(
                count: 2,
                totalPages: 4,
                previousPage: nil,
                nextPage: "https://api.disneyapi.dev/character?page=2"
            ),
            data: [
                TestCharacterInfo.mock(id: 117, name: "Pegasus"),
                TestCharacterInfo.mock(id: 118, name: "Hercules")
            ]
        )

        try service.saveCharactersList(list, page: 1)
        let storedList = try service.getCharactersList(TestCharactersList.self, page: 1)

        XCTAssertEqual(storedList?.info.count, 2)
        XCTAssertEqual(storedList?.info.totalPages, 4)
        XCTAssertNil(storedList?.info.previousPage)
        XCTAssertEqual(storedList?.info.nextPage, "https://api.disneyapi.dev/character?page=2")
        XCTAssertEqual(storedList?.data.map(\.id), [117, 118])
        XCTAssertEqual(storedList?.data.map(\.name), ["Pegasus", "Hercules"])
    }

    func testSaveCharactersListUpsertsExistingPage() throws {
        try service.saveCharactersList(
            TestCharactersList.make(
                pageCount: 1,
                characters: [TestCharacterInfo.mock(id: 117, name: "Pegasus")]
            ),
            page: 1
        )

        try service.saveCharactersList(
            TestCharactersList.make(
                pageCount: 2,
                characters: [
                    TestCharacterInfo.mock(id: 118, name: "Hercules"),
                    TestCharacterInfo.mock(id: 119, name: "Megara")
                ]
            ),
            page: 1
        )

        let storedList = try service.getCharactersList(TestCharactersList.self, page: 1)

        XCTAssertEqual(storedList?.info.count, 2)
        XCTAssertEqual(storedList?.data.map(\.id), [118, 119])
    }

    func testSaveCharacterAndGetCharacterReturnsPersistedCharacter() throws {
        let character = TestCharacterInfo.mock(
            id: 117,
            name: "Pegasus",
            films: ["Hercules"],
            tvShows: ["Hercules TV Series"],
            isFavorite: true
        )

        try service.saveCharacter(character)
        let storedCharacter = try service.getCharacter(TestCharacterInfo.self, id: 117)

        XCTAssertEqual(storedCharacter, character)
    }

    func testSaveCharacterPreservesExistingFavoriteState() throws {
        try service.saveCharacter(
            TestCharacterInfo.mock(id: 117, name: "Pegasus", isFavorite: true)
        )

        try service.saveCharacter(
            TestCharacterInfo.mock(id: 117, name: "Pegasus Updated", isFavorite: false)
        )
        let storedCharacter = try service.getCharacter(TestCharacterInfo.self, id: 117)

        XCTAssertEqual(storedCharacter?.name, "Pegasus Updated")
        XCTAssertEqual(storedCharacter?.isFavorite, true)
    }

    func testSaveCharactersListPreservesFavoriteStateForExistingCharacters() throws {
        try service.saveCharacter(
            TestCharacterInfo.mock(id: 117, name: "Pegasus", isFavorite: true)
        )

        try service.saveCharactersList(
            TestCharactersList.make(
                pageCount: 1,
                characters: [
                    TestCharacterInfo.mock(id: 117, name: "Pegasus", isFavorite: false)
                ]
            ),
            page: 1
        )

        let storedCharacter = try service.getCharacter(TestCharacterInfo.self, id: 117)

        XCTAssertEqual(storedCharacter?.isFavorite, true)
    }

    func testSetCharacterFavoriteUpdatesFavoriteState() throws {
        try service.saveCharacter(
            TestCharacterInfo.mock(id: 117, name: "Pegasus", isFavorite: false)
        )

        try service.setCharacterFavorite(id: 117, isFavorite: true)
        let storedCharacter = try service.getCharacter(TestCharacterInfo.self, id: 117)

        XCTAssertEqual(storedCharacter?.isFavorite, true)
    }

    func testSetCharacterFavoriteThrowsWhenCharacterDoesNotExist() throws {
        XCTAssertThrowsError(try service.setCharacterFavorite(id: 117, isFavorite: true)) { error in
            guard case LocalStorageError.characterNotFound(let id) = error else {
                XCTFail("Expected characterNotFound error, got \(error).")
                return
            }
            XCTAssertEqual(id, 117)
        }
    }

    func testGetFavoriteCharactersReturnsOnlyFavoritesSortedByOrderIndexThenName() throws {
        try service.saveCharactersList(
            TestCharactersList.make(
                pageCount: 3,
                characters: [
                    TestCharacterInfo.mock(id: 1, name: "Pegasus", isFavorite: true),
                    TestCharacterInfo.mock(id: 2, name: "Hercules", isFavorite: false),
                    TestCharacterInfo.mock(id: 3, name: "Megara", isFavorite: true)
                ]
            ),
            page: 1
        )

        let favorites = try service.getFavoriteCharacters(TestCharacterInfo.self)

        XCTAssertEqual(favorites.map(\.id), [1, 3])
        XCTAssertTrue(favorites.allSatisfy(\.isFavorite))
    }

    func testDeleteCharactersListRemovesStoredList() throws {
        try service.saveCharactersList(
            TestCharactersList.make(
                pageCount: 1,
                characters: [TestCharacterInfo.mock(id: 117, name: "Pegasus")]
            ),
            page: 1
        )

        try service.deleteCharactersList(page: 1)
        let storedList = try service.getCharactersList(TestCharactersList.self, page: 1)

        XCTAssertNil(storedList)
    }

    func testDeleteAllCharactersListsRemovesAllStoredLists() throws {
        try service.saveCharactersList(
            TestCharactersList.make(
                pageCount: 1,
                characters: [TestCharacterInfo.mock(id: 117, name: "Pegasus")]
            ),
            page: 1
        )
        try service.saveCharactersList(
            TestCharactersList.make(
                pageCount: 1,
                characters: [TestCharacterInfo.mock(id: 118, name: "Hercules")]
            ),
            page: 2
        )

        try service.deleteAllCharactersLists()

        XCTAssertNil(try service.getCharactersList(TestCharactersList.self, page: 1))
        XCTAssertNil(try service.getCharactersList(TestCharactersList.self, page: 2))
    }
}

private struct TestCharactersList: LocalStorableCharactersList, Equatable {
    typealias Info = TestListInfo
    typealias Character = TestCharacterInfo

    let info: TestListInfo
    let data: [TestCharacterInfo]

    static func make(
        pageCount: Int,
        characters: [TestCharacterInfo]
    ) -> TestCharactersList {
        TestCharactersList(
            info: .init(
                count: pageCount,
                totalPages: 1,
                previousPage: nil,
                nextPage: ""
            ),
            data: characters
        )
    }
}

private struct TestListInfo: LocalStorableListInfo, Equatable {
    let count: Int
    let totalPages: Int
    let previousPage: String?
    let nextPage: String
}

private struct TestCharacterInfo: LocalStorableCharacterInfo, Equatable {
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

    static func mock(
        id: Int,
        name: String,
        films: [String] = [],
        shortFilms: [String] = [],
        tvShows: [String] = [],
        videoGames: [String] = [],
        parkAttractions: [String] = [],
        allies: [String] = [],
        enemies: [String] = [],
        imageUrl: String? = "https://images.example.com/character.png",
        url: String = "https://api.disneyapi.dev/character/117",
        isFavorite: Bool = false
    ) -> TestCharacterInfo {
        TestCharacterInfo(
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
}
