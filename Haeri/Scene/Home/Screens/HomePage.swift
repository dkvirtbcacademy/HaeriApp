//
//  HomePage.swift
//  Haeri
//
//  Created by kv on 05.01.26.
//

import SwiftUI

struct HomePage: View {
    let coordinator: HomeCoordinator
    
    
    init(
        coordinator: HomeCoordinator,
    ) {
        self.coordinator = coordinator
//        _viewModel = StateObject(
//            wrappedValue: HomeViewModel(
//                coordinator: coordinator,
//            )
//        )
    }
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Home")
         }
    }
}

#Preview {
    HomePage(
        coordinator: HomeCoordinator(),
    )
}
