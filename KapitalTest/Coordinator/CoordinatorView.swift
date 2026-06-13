//
//  CoordinatorView.swift
//  KapitalTest
//
//  Created by Sergio Acosta on 12/06/26.
//

import SwiftUI

struct CoordinatorView: View {
    @State private var coordinator = AppCoordinator()
    
    var body: some View {
        @Bindable var bindableCoordinator = coordinator
        
        NavigationStack(path: $bindableCoordinator.path) {
            coordinator.buildView(for: .home)
                .navigationDestination(for: AppRoute.self) { route in
                    coordinator.buildView(for: route)
                }
                .sheet(item: $bindableCoordinator.sheetDestination) { route in
                    coordinator.buildView(for: route)
                }
                .fullScreenCover(item: $bindableCoordinator.coverDestination) { route in
                    coordinator.buildView(for: route)
                }
        }
    }
}
