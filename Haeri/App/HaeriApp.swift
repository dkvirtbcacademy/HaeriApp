//
//  HaeriApp.swift
//  Haeri
//
//  Created by kv on 05.01.26.
//

import SwiftUI

@main
struct HaeriApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @State private var showLaunchScreen = true
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                AppRootView()
                
                if showLaunchScreen {
                    LaunchScreen()
                        .transition(.opacity)
                        .zIndex(1)
                }
            }
            .animation(.easeOut(duration: 0.5), value: showLaunchScreen)
            .task {
                try? await Task.sleep(nanoseconds: 3_000_000_000)
                showLaunchScreen = false
            }
        }
    }
}
