//
//  CommunityPage.swift
//  Haeri
//
//  Created by kv on 06.01.26.
//

import SwiftUI

struct CommunityPage: View {
    let coordinator: CommunityCoordinator
    
    init(
        coordinator: CommunityCoordinator,
    ) {
        self.coordinator = coordinator
    }
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Community")
         }
    }
}

#Preview {
    DashboardPage(coordinator: DashboardCoordinator())
}
