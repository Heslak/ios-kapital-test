//
//  CoordinatorView.swift
//  KapitalTest
//
//  Created by Sergio Acosta on 12/06/26.
//

import SwiftUI

struct CoordinatorView: View {
    @StateObject private var coordinator = AppCoordinator()
    
    var body: some View {
        
        NavigationStack(path: $coordinator.path) {
            coordinator.buildView(for: .home)
                .navigationDestination(for: AppRoute.self) { route in
                    coordinator.buildView(for: route)
                }
        }
    }
}
