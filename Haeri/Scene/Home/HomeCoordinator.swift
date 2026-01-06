//
//  HomeCoordinator.swift
//  Haeri
//
//  Created by kv on 05.01.26.
//

import SwiftUI
import Combine

@MainActor
final class HomeCoordinator: ObservableObject {
    
    enum Destination {
        case details(character: Character)
    }
    
    @Published var path = NavigationPath()
    
    func navigate(to destination: Destination) {
        switch destination {
        case .details(let character):
            path.append(character)
        }
    }
    
    func navigateBack() {
        guard !path.isEmpty else { return }
        path.removeLast()
    }
    
    func popToRoot() {
        path = NavigationPath()
    }
}
