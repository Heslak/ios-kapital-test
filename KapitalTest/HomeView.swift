//
//  HomeView.swift
//  KapitalTest
//
//  Created by Sergio Acosta on 12/06/26.
//

import SwiftUI

struct HomeView: View {
    var coordinator: KapitalTestAppCoordinator
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

#if DEBUG
#Preview {
    HomeView(coordinator: KapitalTestAppCoordinator())
}
#endif
