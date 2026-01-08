//
//  DashboardViewController.swift
//  Haeri
//
//  Created by kv on 06.01.26.
//

import UIKit

class DashboardViewController: UIViewController {

    private let coordinator: DashboardCoordinator
    private let authManager: AuthManager
    private var airQualityValue: Int = 25
    
    init(coordinator: DashboardCoordinator, authManager: AuthManager) {
        self.coordinator = coordinator
        self.authManager = authManager
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addAdaptiveBackground(value: airQualityValue)
        
        setupUI()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateBackgroundFrame()
    }
    
    func updateAirQuality(_ value: Int) {
        airQualityValue = value
        addAdaptiveBackground(value: value, animated: true)
    }
    
    private func setupUI() {
        
    }
}
