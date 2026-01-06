//
//  DashboardPage.swift
//  Haeri
//
//  Created by kv on 06.01.26.
//

import SwiftUI

struct DashboardPage: View {
    let coordinator: DashboardCoordinator
    
    init(
        coordinator: DashboardCoordinator,
    ) {
        self.coordinator = coordinator
    }
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Dashboard")
         }
    }
}

#Preview {
    DashboardPage(coordinator: DashboardCoordinator())
}
