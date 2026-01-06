//
//  DashboardFlowView.swift
//  Haeri
//
//  Created by kv on 06.01.26.
//

import SwiftUI

struct DashboardFlowView: View {
    @ObservedObject var coordinator: DashboardCoordinator
    @Environment(\.airQuality) var airQuality
    
    var body: some View {
        NavigationStack(path: $coordinator.path) {
            DashboardPage(
                coordinator: coordinator,
            )
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .navigationDestination(for: Int.self) { id in }
            .adaptiveBackground()
        }
    }
}

#Preview {
    DashboardFlowView(coordinator: DashboardCoordinator())
}
