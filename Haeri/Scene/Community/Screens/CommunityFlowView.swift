//
//  CommunityFlowView.swift
//  Haeri
//
//  Created by kv on 06.01.26.
//

import SwiftUI

struct CommunityFlowView: View {
    @ObservedObject var coordinator: CommunityCoordinator
    @Environment(\.airQuality) var airQuality
    
    var body: some View {
        NavigationStack(path: $coordinator.path) {
            CommunityPage(
                coordinator: coordinator,
            )
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .navigationDestination(for: Int.self) { id in }
            .adaptiveBackground()
        }
    }
}

#Preview {
    CommunityFlowView(coordinator: CommunityCoordinator())
}
