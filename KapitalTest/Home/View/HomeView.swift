//
//  HomeView.swift
//  KapitalTest
//
//  Created by Sergio Acosta on 12/06/26.
//

import SwiftUI

struct HomeView: View {
    @ObservedObject var coordinator: AppCoordinator
    @StateObject private var viewModel: HomeViewModel
    
    init(
        viewModel: HomeViewModel,
        coordinator: AppCoordinator,
    ) {
        _viewModel = StateObject(wrappedValue: viewModel)
        _coordinator = ObservedObject(wrappedValue: coordinator)
    }
    
    var body: some View {
        buildBody().onAppear {
            Task {
                await viewModel.fetchUsers()
            }
        }
    }
    
    @ViewBuilder
    func buildBody() -> some View {
        switch viewModel.state {
        case .loading:
            Text("Loading!")
        case .shouldLoad:
            Text("ShoulLoad from disk")
        case .loaded(let charactersList):
            Text("Loaded \(charactersList.data.first?.name ?? "no data")")
        case .error:
            Text("Error!")
        }
    }
}

#if DEBUG
#Preview {
    HomeView(
        viewModel: HomeViewModel(fetchUsersUseCase: FetchUsersUseCaseMock()),
        coordinator: AppCoordinator()
    )
}

struct FetchUsersUseCaseMock: FetchUsersUseCaseProtocol {
    func execute(page: Int) async throws -> CharactersList {
        CharactersList(
            info:
                ListInfo(
                    count: 0,
                    totalPages: 0,
                    previousPage: "",
                    nextPage: ""
                )
            , data: [
                
            ]
        )
    }
}
#endif
