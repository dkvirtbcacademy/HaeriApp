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
    private var airQualityValue: Int = 1
    private var cancellables = Set<AnyCancellable>()
    
    private var lastScrollOffset: CGFloat = 0
    private var isButtonVisible: Bool = true
    
    private let headerView: UIView = {
        let view = UIView()
        view.applyMediumGlass(cornerRadius: 0)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let logoView: UIImageView = {
        let logo = UIImageView()
        logo.contentMode = .scaleAspectFit
        logo.translatesAutoresizingMaskIntoConstraints = false
        logo.image = UIImage(named: "Haeri Logo")
        return logo
    }()
    
    private let headerLabel: UILabel = {
        let label = UILabel()
        label.font = .firagoMedium(.xxsmall)
        label.textColor = .darkText
        label.text = "ჰაერის ხარისხი"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
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
    
    private lazy var loadingHostingController: UIHostingController<ExpandingRings> = {
        let loadingView = ExpandingRings()
        let hostingController = UIHostingController(rootView: loadingView)
        hostingController.view.backgroundColor = .clear
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        hostingController.view.isHidden = true
        return hostingController
    }()
    
    private lazy var addCityButtonHostingController: UIHostingController<AddCityButton> = {
        let button = AddCityButton(
            isVisible: isButtonVisible,
            label: "დაამატე ქალაქი"
        ) { [weak self] in
            self?.presentAddCitySheet()
        }
        let hostingController = UIHostingController(rootView: button)
        hostingController.view.backgroundColor = .clear
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        return hostingController
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
        setHeaderView()
        setTableView()
        setupLoadingIndicator()
        setupAddCityButton()
    }
    
    private func setHeaderView() {
//        headerView.addSubview(headerLabel)
        headerView.addSubview(logoView)
        view.addSubview(headerView)
        
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 120),
            
            logoView.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            logoView.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -20),
            logoView.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    private func setTableView() {
        view.addSubview(tableView)
        
        tableView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 60, right: 0)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    private func setupLoadingIndicator() {
        addChild(loadingHostingController)
        view.addSubview(loadingHostingController.view)
        loadingHostingController.didMove(toParent: self)
        
        NSLayoutConstraint.activate([
            loadingHostingController.view.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingHostingController.view.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            loadingHostingController.view.widthAnchor.constraint(equalToConstant: 80),
            loadingHostingController.view.heightAnchor.constraint(equalToConstant: 80)
        ])
    }
    
    private func setupAddCityButton() {
        addChild(addCityButtonHostingController)
        view.addSubview(addCityButtonHostingController.view)
        addCityButtonHostingController.didMove(toParent: self)
        
        NSLayoutConstraint.activate([
            addCityButtonHostingController.view.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            addCityButtonHostingController.view.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            addCityButtonHostingController.view.widthAnchor.constraint(equalToConstant: 220),
            addCityButtonHostingController.view.heightAnchor.constraint(equalToConstant: 70)
        ])
    }
    
    private func presentAddCitySheet() {
        viewModel.navigateToAddCity(delegate: self)
    }
    
    private func updateButtonVisibility(_ isVisible: Bool) {
        let button = AddCityButton(
            isVisible: isVisible,
            label: "დაამატე ქალაქი"
        ) { [weak self] in
            self?.presentAddCitySheet()
        }
        addCityButtonHostingController.rootView = button
    }
    
    private func bindViewModel() {
        viewModel.$cities
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self = self else { return }
                
                CATransaction.begin()
                CATransaction.setDisableActions(true)
                UIView.performWithoutAnimation {
                    self.tableView.reloadData()
                }
                CATransaction.commit()
            }
            .store(in: &cancellables)
        
        viewModel.$isLoading
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isLoading in
                self?.loadingHostingController.view.isHidden = !isLoading
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
        let isFavorite = viewModel.isFavoriteCity(cityData.city)
        
        cell.configure(with: cityData, isFavorite: isFavorite)
        
        cell.onFavoriteTapped = { [weak self] in
            self?.viewModel.setFavoriteCity(cityData.city)
            
            UIView.performWithoutAnimation {
                self?.tableView.reloadData()
            }
        }
        
        return cell
    }
}

extension DashboardViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let cityData = viewModel.cities[indexPath.row]
        
        viewModel.navigateToCityDetail(cityData: cityData, backgroudColor: cityData.response.item?.aqiCategory.color ?? "Green Air")
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            viewModel.removeCity(at: indexPath.row)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentOffset = scrollView.contentOffset.y
        let diff = currentOffset - lastScrollOffset
        
        if diff > 5 && isButtonVisible && currentOffset > 50 {
            isButtonVisible = false
            updateButtonVisibility(false)
        }
        else if (diff < -5 || currentOffset < 30) && !isButtonVisible {
            isButtonVisible = true
            updateButtonVisibility(true)
        }
        
        lastScrollOffset = currentOffset
    }
}

extension DashboardViewController: AddCityViewControllerDelegate {
    func didSelectCity(_ city: GeoResponse) {
        Task {
            await viewModel.addCity(city)
        }
    }
}
