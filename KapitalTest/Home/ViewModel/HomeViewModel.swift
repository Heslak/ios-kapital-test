//
//  HomeViewModel.swift
//  KapitalTest
//
//  Created by Sergio Acosta on 12/06/26.
//

import Foundation
import Combine

enum ViewState: Equatable {
    case shouldLoad
    case loading
    case loaded(charactersList: CharactersList)
    case error
    
    static func == (lhs: ViewState, rhs: ViewState) -> Bool {
        switch (lhs, rhs) {
        case (.shouldLoad, .shouldLoad):
            return true
        case (.loading, .loading):
            return true
        case (.loaded(let lhsCL), .loaded(let rhsCL)):
            return lhsCL.info.nextPage == rhsCL.info.nextPage &&
                    lhsCL.info.previousPage == rhsCL.info.previousPage
        case (.error, .error):
            return true
        default:
            return false
        }
    }
}

class HomeViewModel: ObservableObject {
    private let fetchUsersUseCase: FetchUsersUseCaseProtocol
    
    @Published var state: ViewState = .shouldLoad
    
    init(fetchUsersUseCase: FetchUsersUseCaseProtocol) {
        self.fetchUsersUseCase = fetchUsersUseCase
    }
    
    func fetchUsers() async {
        guard state != .loading else { return }
        do {
            let charactersList = try await fetchUsersUseCase.execute(page: 1)
            state = .loaded(charactersList: charactersList)
        } catch let error {
            state = .error
        }
    }
}
