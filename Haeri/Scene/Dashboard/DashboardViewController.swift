//
//  DashboardViewController.swift
//  Haeri
//
//  Created by kv on 06.01.26.
//

import UIKit
import Combine
import SwiftUI

class DashboardViewController: UIViewController {

    private let viewModel: DashboardViewModel
    private var airQualityValue: Int = 25
    private var cancellables = Set<AnyCancellable>()
    
    private lazy var tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .plain)
        table.translatesAutoresizingMaskIntoConstraints = false
        table.delegate = self
        table.dataSource = self
        table.register(CityAirPollutionCell.self, forCellReuseIdentifier: CityAirPollutionCell.identifier)
        table.backgroundColor = .clear
        table.separatorStyle = .none
        return table
    }()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    init(viewModel: DashboardViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addAdaptiveBackground(value: airQualityValue)
        setupUI()
        bindViewModel()
        fetchData()
        
         edgesForExtendedLayout = .all
         extendedLayoutIncludesOpaqueBars = true
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
        navigationItem.title = "Air Quality"
        
        view.addSubview(tableView)
        view.addSubview(activityIndicator)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func bindViewModel() {
        viewModel.$cities
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.tableView.reloadData()
            }
            .store(in: &cancellables)
        
        viewModel.$isLoading
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isLoading in
                if isLoading {
                    self?.activityIndicator.startAnimating()
                } else {
                    self?.activityIndicator.stopAnimating()
                }
            }
            .store(in: &cancellables)
    }
    
    private func fetchData() {
        Task {
            await viewModel.fetchCitiesData()
        }
    }
}

extension DashboardViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.cities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: CityAirPollutionCell.identifier,
            for: indexPath
        ) as? CityAirPollutionCell else {
            return UITableViewCell()
        }
        
        let cityData = viewModel.cities[indexPath.row]
        cell.configure(with: cityData)
        
        return cell
    }
}

extension DashboardViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let cityData = viewModel.cities[indexPath.row]
        
        viewModel.navigateToCityDetail(cityData: cityData, calculateBackground: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            viewModel.removeCity(at: indexPath.row)
        }
    }
}
