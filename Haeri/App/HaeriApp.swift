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
    
    @StateObject private var dependencies = AppDependencies()
    @State private var showLaunchScreen = true
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                AppRootView(
                    appCoordinator: dependencies.appCoordinator,
                    dependencies: dependencies
                )
                
                if showLaunchScreen {
                    LaunchScreen()
                        .transition(.opacity)
                        .zIndex(1)
                }
            }
            .animation(.easeOut(duration: 0.5), value: showLaunchScreen)
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                    showLaunchScreen = false
                }
            }
        }
    }
}
