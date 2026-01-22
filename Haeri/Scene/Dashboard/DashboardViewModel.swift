//
//  DashboardViewModel.swift
//  Haeri
//
//  Created by kv on 09.01.26.
//

import Foundation
import Combine

final class DashboardViewModel: ObservableObject {
    
    @Published var cities: [CityAirPollution] = []
    @Published var isLoading: Bool = false
    
    @Published var searchText: String = ""
    @Published var searchResults: [GeoResponse] = []
    @Published var isSearchLoading: Bool = false
    @Published var showEmptyState: Bool = false
    
    private let coordinator: DashboardCoordinator
    private let homeCoordinator: HomeCoordinator
    private let airPollutionManager: AirPollutionManager
    private let aiRecommendationManager: AIRecomendationManager
    private var cancellables = Set<AnyCancellable>()
    
    init(
        coordinator: DashboardCoordinator,
        homeCoordinator: HomeCoordinator,
        airPollutionManager: AirPollutionManager,
        aiRecommendationManager: AIRecomendationManager
    ) {
        self.coordinator = coordinator
        self.homeCoordinator = homeCoordinator
        self.airPollutionManager = airPollutionManager
        self.aiRecommendationManager = aiRecommendationManager
        observeAirPollutionData()
        setupSearchDebounce()
    }
    
    private func observeAirPollutionData() {
        airPollutionManager.$airPollutionData
            .assign(to: &$cities)
        
        airPollutionManager.$isLoading
            .assign(to: &$isLoading)
    }
    
    private func setupSearchDebounce() {
        $searchText
            .debounce(for: .milliseconds(500), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .filter { $0.count >= 2 || $0.isEmpty }
            .sink { [weak self] query in
                self?.performSearch(query: query)
            }
            .store(in: &cancellables)
    }
    
    private func performSearch(query: String) {
        guard !query.isEmpty else {
            clearSearch()
            return
        }
        
        searchResults = []
        airPollutionManager.clearSearchResults()
        isSearchLoading = true
        showEmptyState = false
        
        Task {
            await airPollutionManager.findCity(city: query)
            
            await MainActor.run { [weak self] in
                guard let self = self else { return }
                self.isSearchLoading = false
                self.searchResults = self.airPollutionManager.searchResults
                self.showEmptyState = self.searchResults.isEmpty
            }
        }
    }
    
    func clearSearch() {
        searchText = ""
        searchResults = []
        showEmptyState = false
        isSearchLoading = false
        airPollutionManager.clearSearchResults()
    }
    
    func fetchCitiesData() async {
        await airPollutionManager.fetchChoosenCitiesData()
    }
    
    func findCity(name: String) async {
        await airPollutionManager.findCity(city: name)
    }
    
    func getSearchResults() -> [GeoResponse] {
        airPollutionManager.searchResults
    }
    
    func addCity(_ city: GeoResponse) async {
        await airPollutionManager.addChoosenCity(
            city: city.name,
            lat: city.lat,
            lon: city.lon
        )
    }
    
    func setFavoriteCity(_ cityName: String) {
        airPollutionManager.setFavoriteCity(cityName)
    }
    
    func isFavoriteCity(_ cityName: String) -> Bool {
        return airPollutionManager.isFavoriteCity(cityName)
    }
    
    func removeCity(at index: Int) {
        guard index < cities.count else { return }
        let cityName = cities[index].city
        airPollutionManager.removeChoosenCity(cityName: cityName)
    }
    
    func navigateToCityDetail(cityData: CityAirPollution, backgroudColor: String) {
        coordinator.navigate(
            to: .cityDetail(
                cityData,
                homeCoordinator,
                aiRecommendationManager,
                backgroudColor
            )
        )
    }
    
    func navigateToAddCity(delegate: AddCityViewControllerDelegate) {
        coordinator.navigate(to: .addCity(self, delegate))
    }
}
