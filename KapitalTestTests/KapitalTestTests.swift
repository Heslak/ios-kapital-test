//
//  KapitalTestTests.swift
//  KapitalTestTests
//
//  Created by Sergio Acosta on 12/06/26.
//

import XCTest
@testable import KapitalTest

@MainActor
final class KapitalTestTests: XCTestCase {
    
    func testHomeFetchUsersLoadsCharactersAndSetsLoadedState() async {
        let expectedList = CharactersList.makeMock(
            page: 1,
            nextPage: "2",
            characters: [
                .makeMock(id: 117, name: "Pegasus")
            ]
        )
        let useCase = FetchUsersUseCaseSpy(result: .success([expectedList]))
        let viewModel = HomeViewModel(fetchUsersUseCase: useCase)
        
        await viewModel.fetchUsers()
        
        XCTAssertEqual(viewModel.state, .loaded)
        XCTAssertEqual(viewModel.charactersList?.info.totalPages, expectedList.info.totalPages)
        XCTAssertEqual(viewModel.charactersList?.data.map(\.id), [117])
        XCTAssertEqual(useCase.requestedPages, [1])
    }
    
    func testHomeFetchUsersSetsErrorStateWhenUseCaseFails() async {
        let useCase = FetchUsersUseCaseSpy(result: .failure(TestError.expected))
        let viewModel = HomeViewModel(fetchUsersUseCase: useCase)
        
        await viewModel.fetchUsers()
        
        XCTAssertEqual(viewModel.state, .error)
        XCTAssertNil(viewModel.charactersList)
    }
    
    func testHomeLoadNextPageAppendsCharactersWhenCurrentCharacterIsLast() async {
        let firstPage = CharactersList.makeMock(
            page: 1,
            nextPage: "2",
            characters: [
                .makeMock(id: 1, name: "Achilles")
            ]
        )
        let secondPage = CharactersList.makeMock(
            page: 2,
            nextPage: "",
            characters: [
                .makeMock(id: 2, name: "Hercules")
            ]
        )
        let useCase = FetchUsersUseCaseSpy(
            pages: [
                1: .success([firstPage]),
                2: .success([secondPage])
            ]
        )
        let viewModel = HomeViewModel(fetchUsersUseCase: useCase)
        
        await viewModel.fetchUsers()
        await viewModel.loadNextPageIfNeeded(currentCharacter: firstPage.data[0])
        
        XCTAssertEqual(viewModel.state, .loaded)
        XCTAssertEqual(viewModel.charactersList?.data.map(\.id), [1, 2])
        XCTAssertEqual(useCase.requestedPages, [1, 2])
    }
    
    func testHomeLoadNextPageDoesNotRequestPageWhenCurrentCharacterIsNotLast() async {
        let list = CharactersList.makeMock(
            page: 1,
            nextPage: "2",
            characters: [
                .makeMock(id: 1, name: "Achilles"),
                .makeMock(id: 2, name: "Hercules")
            ]
        )
        let useCase = FetchUsersUseCaseSpy(result: .success([list]))
        let viewModel = HomeViewModel(fetchUsersUseCase: useCase)
        
        await viewModel.fetchUsers()
        await viewModel.loadNextPageIfNeeded(currentCharacter: list.data[0])
        
        XCTAssertEqual(viewModel.charactersList?.data.map(\.id), [1, 2])
        XCTAssertEqual(useCase.requestedPages, [1])
    }
    
    func testHomeToggleFavoriteUpdatesCharacterAndPersistsChange() async {
        let list = CharactersList.makeMock(
            characters: [
                .makeMock(id: 117, name: "Pegasus", isFavorite: false)
            ]
        )
        let useCase = FetchUsersUseCaseSpy(result: .success([list]))
        let viewModel = HomeViewModel(fetchUsersUseCase: useCase)
        
        await viewModel.fetchUsers()
        viewModel.toggleFavorite(for: list.data[0])
        
        XCTAssertEqual(viewModel.charactersList?.data.first?.isFavorite, true)
        XCTAssertEqual(useCase.favoriteUpdates, [.init(id: 117, isFavorite: true)])
    }
    
    func testHomeToggleFavoriteRollsBackWhenPersistenceFails() async {
        let character = CharacterInfo.makeMock(id: 117, name: "Pegasus", isFavorite: false)
        let list = CharactersList.makeMock(characters: [character])
        let useCase = FetchUsersUseCaseSpy(result: .success([list]))
        useCase.favoriteError = TestError.expected
        let viewModel = HomeViewModel(fetchUsersUseCase: useCase)
        
        await viewModel.fetchUsers()
        viewModel.toggleFavorite(for: character)
        
        XCTAssertEqual(viewModel.charactersList?.data.first?.isFavorite, false)
    }
    
    func testCharacterDetailFetchCharacterLoadsCharacterAndSetsLoadedState() async {
        let character = CharacterInfo.makeMock(id: 117, name: "Pegasus")
        let useCase = FetchCharacterDetailUseCaseSpy(result: .success([character]))
        let viewModel = CharacterDetailViewModel(
            characterId: 117,
            fetchCharacterDetailUseCase: useCase
        )
        
        await viewModel.fetchCharacter()
        
        // Give background tasks time to complete
        try? await Task.sleep(nanoseconds: 500_000_000)
        
        XCTAssertEqual(viewModel.state, .loaded)
        XCTAssertEqual(viewModel.character?.id, 117)
        XCTAssertEqual(useCase.requestedIds, [117])
    }
    
    func testCharacterDetailFetchCharacterSetsErrorStateWhenUseCaseFails() async {
        let useCase = FetchCharacterDetailUseCaseSpy(result: .failure(TestError.expected))
        let viewModel = CharacterDetailViewModel(
            characterId: 117,
            fetchCharacterDetailUseCase: useCase
        )
        
        await viewModel.fetchCharacter()
        
        // Give background tasks time to complete
        try? await Task.sleep(nanoseconds: 500_000_000)
        
        XCTAssertEqual(viewModel.state, .error)
        XCTAssertNil(viewModel.character)
    }
    
    func testCharacterDetailToggleFavoriteUpdatesCharacterAndPersistsChange() async {
        let character = CharacterInfo.makeMock(id: 117, name: "Pegasus", isFavorite: false)
        let useCase = FetchCharacterDetailUseCaseSpy(result: .success([character]))
        let viewModel = CharacterDetailViewModel(
            characterId: 117,
            fetchCharacterDetailUseCase: useCase
        )
        
        await viewModel.fetchCharacter()
        try? await Task.sleep(nanoseconds: 100_000_000)
        viewModel.toggleFavorite()
        
        XCTAssertEqual(viewModel.character?.isFavorite, true)
        XCTAssertEqual(useCase.favoriteUpdates, [.init(id: 117, isFavorite: true)])
    }
    
    func testCharacterDetailToggleFavoriteRollsBackWhenPersistenceFails() async {
        let character = CharacterInfo.makeMock(id: 117, name: "Pegasus", isFavorite: false)
        let useCase = FetchCharacterDetailUseCaseSpy(result: .success([character]))
        useCase.favoriteError = TestError.expected
        let viewModel = CharacterDetailViewModel(
            characterId: 117,
            fetchCharacterDetailUseCase: useCase
        )
        
        await viewModel.fetchCharacter()
        try? await Task.sleep(nanoseconds: 500_000_000)
        viewModel.toggleFavorite()
        
        XCTAssertEqual(viewModel.character?.isFavorite, false)
    }
    
    func testFavoriteCharactersFetchLoadsCharactersAndSetsLoadedState() async {
        let characters = [
            CharacterInfo.makeMock(id: 1, name: "Achilles", isFavorite: true),
            CharacterInfo.makeMock(id: 2, name: "Hercules", isFavorite: true)
        ]
        let useCase = FetchFavoriteCharactersUseCaseSpy(fetchResult: .success(characters))
        let viewModel = FavoriteCharactersViewModel(fetchFavoriteCharactersUseCase: useCase)
        
        viewModel.fetchFavoriteCharacters()
        try? await Task.sleep(nanoseconds: 100_000_000)
        
        XCTAssertEqual(viewModel.state, .loaded)
        XCTAssertEqual(viewModel.characters.map(\.id), [1, 2])
    }
    
    func testFavoriteCharactersFetchSetsErrorStateWhenUseCaseFails() async {
        let useCase = FetchFavoriteCharactersUseCaseSpy(fetchResult: .failure(TestError.expected))
        let viewModel = FavoriteCharactersViewModel(fetchFavoriteCharactersUseCase: useCase)
        
        viewModel.fetchFavoriteCharacters()
        try? await Task.sleep(nanoseconds: 100_000_000)
        
        XCTAssertEqual(viewModel.state, .error)
        XCTAssertTrue(viewModel.characters.isEmpty)
    }
    
    func testFavoriteCharactersToggleFavoriteRemovesCharacterAndRefreshesList() async {
        let character = CharacterInfo.makeMock(id: 117, name: "Pegasus", isFavorite: true)
        let useCase = FetchFavoriteCharactersUseCaseSpy(
            fetchResults: [
                .success([character]),
                .success([])
            ]
        )
        let viewModel = FavoriteCharactersViewModel(fetchFavoriteCharactersUseCase: useCase)
        
        viewModel.fetchFavoriteCharacters()
        try? await Task.sleep(nanoseconds: 100_000_000)
        viewModel.toggleFavorite(for: character)
        try? await Task.sleep(nanoseconds: 100_000_000)
        
        XCTAssertTrue(viewModel.characters.isEmpty)
        XCTAssertEqual(useCase.favoriteUpdates, [.init(id: 117, isFavorite: false)])
        XCTAssertEqual(useCase.fetchCallCount, 2)
    }
    
    func testFavoriteCharactersToggleFavoriteRestoresCharactersWhenPersistenceFails() async {
        let character = CharacterInfo.makeMock(id: 117, name: "Pegasus", isFavorite: true)
        let useCase = FetchFavoriteCharactersUseCaseSpy(fetchResult: .success([character]))
        useCase.favoriteError = TestError.expected
        let viewModel = FavoriteCharactersViewModel(fetchFavoriteCharactersUseCase: useCase)
        
        viewModel.fetchFavoriteCharacters()
        try? await Task.sleep(nanoseconds: 100_000_000)
        try? await Task.sleep(nanoseconds: 100_000_000)
        viewModel.toggleFavorite(for: character)
        
        XCTAssertEqual(viewModel.characters.map(\.id), [117])
        XCTAssertEqual(viewModel.characters.first?.isFavorite, true)
    }
    
    func testCharacterInfoSettingFavoriteReturnsCopyWithUpdatedFavoriteState() {
        let character = CharacterInfo.makeMock(id: 117, name: "Pegasus", isFavorite: false)
        
        let favoriteCharacter = character.settingFavorite(true)
        
        XCTAssertEqual(favoriteCharacter.id, character.id)
        XCTAssertEqual(favoriteCharacter.name, character.name)
        XCTAssertTrue(favoriteCharacter.isFavorite)
        XCTAssertFalse(character.isFavorite)
    }
    
    func testCharacterInfoTotalCountStatsIncludesContentSections() {
        let character = CharacterInfo.makeMock(
            films: ["Hercules"],
            shortFilms: ["Short"],
            tvShows: ["Hercules TV"],
            videoGames: ["Game"],
            parkAttractions: ["Disneyland"]
        )
        
        XCTAssertEqual(character.totalCountStats, 5)
    }
    
    func testAppRouteIdentifierIncludesRoutePayload() {
        XCTAssertEqual(AppRoute.home.id, "home")
        XCTAssertEqual(AppRoute.detail(id: 117).id, "detail-117")
    }
}

private final class FetchUsersUseCaseSpy: FetchUsersUseCaseProtocol {
    private let pages: [Int: Result<[CharactersList], Error>]
    private let fallbackResult: Result<[CharactersList], Error>
    private(set) var requestedPages: [Int] = []
    private(set) var favoriteUpdates: [FavoriteUpdate] = []
    var favoriteError: Error?
    
    init(result: Result<[CharactersList], Error>) {
        self.pages = [:]
        self.fallbackResult = result
    }
    
    init(pages: [Int: Result<[CharactersList], Error>]) {
        self.pages = pages
        self.fallbackResult = .failure(TestError.unexpectedPage)
    }
    
    func fetchUsers(page: Int) -> AsyncThrowingStream<CharactersList, Error> {
        requestedPages.append(page)
        return Self.makeStream(from: pages[page] ?? fallbackResult)
    }
    
    func setFavorite(
        id: Int,
        isFavorite: Bool
    ) throws {
        favoriteUpdates.append(.init(id: id, isFavorite: isFavorite))
        
        if let favoriteError {
            throw favoriteError
        }
    }
}

private final class FetchCharacterDetailUseCaseSpy: FetchCharacterDetailUseCaseProtocol {
    private let result: Result<[CharacterInfo], Error>
    private(set) var requestedIds: [Int] = []
    private(set) var favoriteUpdates: [FavoriteUpdate] = []
    var favoriteError: Error?
    
    init(result: Result<[CharacterInfo], Error>) {
        self.result = result
    }
    
    func fetchCharacter(id: Int) -> AsyncThrowingStream<CharacterInfo, Error> {
        requestedIds.append(id)
        return Self.makeStream(from: result)
    }
    
    func setFavorite(
        id: Int,
        isFavorite: Bool
    ) throws {
        favoriteUpdates.append(.init(id: id, isFavorite: isFavorite))
        
        if let favoriteError {
            throw favoriteError
        }
    }
}

private final class FetchFavoriteCharactersUseCaseSpy: FetchFavoriteCharactersUseCaseProtocol {
    private var fetchResults: [Result<[CharacterInfo], Error>]
    private(set) var favoriteUpdates: [FavoriteUpdate] = []
    private(set) var fetchCallCount = 0
    var favoriteError: Error?
    
    init(fetchResult: Result<[CharacterInfo], Error>) {
        self.fetchResults = [fetchResult]
    }
    
    init(fetchResults: [Result<[CharacterInfo], Error>]) {
        self.fetchResults = fetchResults
    }
    
    func fetchFavoriteCharacters() throws -> [CharacterInfo] {
        fetchCallCount += 1
        let result = fetchResults.isEmpty ? .success([]) : fetchResults.removeFirst()
        
        switch result {
        case .success(let characters):
            return characters
        case .failure(let error):
            throw error
        }
    }
    
    func setFavorite(
        id: Int,
        isFavorite: Bool
    ) throws {
        favoriteUpdates.append(.init(id: id, isFavorite: isFavorite))
        
        if let favoriteError {
            throw favoriteError
        }
    }
}

private struct FavoriteUpdate: Equatable {
    let id: Int
    let isFavorite: Bool
}

private enum TestError: Error {
    case expected
    case unexpectedPage
}

private extension FetchUsersUseCaseSpy {
    static func makeStream(from result: Result<[CharactersList], Error>) -> AsyncThrowingStream<CharactersList, Error> {
        AsyncThrowingStream { continuation in
            switch result {
            case .success(let lists):
                lists.forEach { continuation.yield($0) }
                continuation.finish()
            case .failure(let error):
                continuation.finish(throwing: error)
            }
        }
    }
}

private extension FetchCharacterDetailUseCaseSpy {
    static func makeStream(from result: Result<[CharacterInfo], Error>) -> AsyncThrowingStream<CharacterInfo, Error> {
        AsyncThrowingStream { continuation in
            switch result {
            case .success(let characters):
                characters.forEach { continuation.yield($0) }
                continuation.finish()
            case .failure(let error):
                continuation.finish(throwing: error)
            }
        }
    }
}

private extension CharactersList {
    static func makeMock(
        page: Int = 1,
        totalPages: Int = 1,
        nextPage: String = "",
        characters: [CharacterInfo]
    ) -> CharactersList {
        CharactersList(
            info: ListInfo(
                count: characters.count,
                totalPages: totalPages,
                previousPage: page > 1 ? "\(page - 1)" : nil,
                nextPage: nextPage
            ),
            data: characters
        )
    }
}

private extension CharacterInfo {
    static func makeMock(
        id: Int = 117,
        films: [String] = ["Hercules"],
        shortFilms: [String] = [],
        tvShows: [String] = ["Hercules"],
        videoGames: [String] = [],
        parkAttractions: [String] = ["Disneyland"],
        allies: [String] = ["Hercules", "Philoctetes"],
        enemies: [String] = ["Hades"],
        name: String = "Pegasus",
        imageUrl: String? = nil,
        url: String = "",
        isFavorite: Bool = false
    ) -> CharacterInfo {
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
}
