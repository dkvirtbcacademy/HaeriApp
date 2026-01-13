//
//  ProfileViewModel.swift
//  Haeri
//
//  Created by kv on 12.01.26.
//

import Foundation
import Combine

final class ProfileViewModel: ObservableObject {
    
    let coordinator: ProfileCoordinator
    let authManager: AuthManager
    
    var airQualityValue: Int = 25
    
    init(coordinator: ProfileCoordinator, authManager: AuthManager) {
        self.coordinator = coordinator
        self.authManager = authManager
    }
}
