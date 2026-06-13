//
//  AppCoordinator.swift
//  KapitalTest
//
//  Created by Sergio Acosta on 12/06/26.
//

import SwiftUI

@Observable
class AppCoordinator {
    
    var path = NavigationPath()
       
       // Manages sheet presentation
       var sheetDestination: AppRoute?
       
       // Manages full-screen cover presentation
       var coverDestination: AppRoute?
       
       // MARK: - Navigation Actions
       
       func push(_ route: AppRoute) {
           path.append(route)
       }
       
       func pop() {
           guard !path.isEmpty else { return }
           path.removeLast()
       }
       
       func popToRoot() {
           path = NavigationPath()
       }
       
       func presentSheet(_ route: AppRoute) {
           sheetDestination = route
       }
       
       func dismissSheet() {
           sheetDestination = nil
       }
       
       func presentCover(_ route: AppRoute) {
           coverDestination = route
       }
       
       func dismissCover() {
           coverDestination = nil
       }
       
       // MARK: - View Factory
       // Centralizes view generation and dependency injection
       @ViewBuilder
       func buildView(for route: AppRoute) -> some View {
           switch route {
           case .home:
               HomeView(coordinator: self)
           case .detail(let item):
               ContentView()
           }
       }
}
