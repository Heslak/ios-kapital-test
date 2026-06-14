//
//  FetchUsersUseCaseProtocol.swift
//  KapitalTest
//
//  Created by Sergio Acosta on 12/06/26.
//


protocol FetchUsersUseCaseProtocol {
    func execute(page: Int) async throws -> CharactersList
}

final class FetchUsersUseCase: FetchUsersUseCaseProtocol {
    private let repository: HomeRepositoryProtocol
    
    // Inyección de dependencias a través de la interfaz del repositorio
    init(repository: HomeRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute(page: Int) async throws -> CharactersList {
        // Aquí se puede agregar lógica de negocio (filtrado extra, validaciones, etc.)
        return try await repository.fetchList(page: page)
    }
}
