//
//  AppDelegate.swift
//  Haeri
//
//  Created by kv on 18.01.26.
//

import SwiftUI
import FirebaseCore
import FirebaseAuth

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
    ) -> Bool {
        FirebaseApp.configure()
        
        checkAndHandleFirstLaunch()
        
        return true
    }
    
    private func checkAndHandleFirstLaunch() {
        let hasLaunchedBefore = UserDefaults.standard.bool(forKey: "hasLaunchedBefore")
        
        if !hasLaunchedBefore {
            do {
                try Auth.auth().signOut()
            } catch {
                print("Error signing out on fresh install: \(error)")
            }
            
            UserDefaults.standard.set(true, forKey: "hasLaunchedBefore")
        }
    }
}
