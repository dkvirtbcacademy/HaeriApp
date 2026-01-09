//
//  CityAirPollutionCell.swift
//  Haeri
//
//  Created by kv on 09.01.26.
//

import UIKit

class CityAirPollutionCell: UITableViewCell {
    
    static let identifier = "CityAirPollutionCell"
    
    private let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemBackground.withAlphaComponent(0.9)
        view.layer.cornerRadius = 12
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.1
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 4
        return view
    }()
    
    private let cityNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.textColor = .label
        return label
    }()
    
    private let aqiLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 32, weight: .bold)
        label.textColor = .label
        return label
    }()
    
    private let componentsStackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.spacing = 8
        return stack
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = .clear
        selectionStyle = .none
        
        contentView.addSubview(containerView)
        containerView.addSubview(cityNameLabel)
        containerView.addSubview(aqiLabel)
        containerView.addSubview(componentsStackView)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            
            cityNameLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 12),
            cityNameLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            
            aqiLabel.topAnchor.constraint(equalTo: cityNameLabel.bottomAnchor, constant: 8),
            aqiLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            
            componentsStackView.topAnchor.constraint(equalTo: aqiLabel.bottomAnchor, constant: 12),
            componentsStackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            componentsStackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            componentsStackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -12)
        ])
    }
    
    func configure(with cityData: CityAirPollution) {
        guard let pollutionData = cityData.response.list.first else { return }
        
        cityNameLabel.text = cityData.city
        
        let aqi = pollutionData.main.aqi
        aqiLabel.text = "\(aqi)"
        
        setupComponents(pollutionData.components)
    }
    
    private func setupComponents(_ components: AirPollutionResponse.AirPollutionItem.Components) {
        componentsStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        let componentData = [
            ("PM2.5", components.pm2_5),
            ("PM10", components.pm10),
            ("O₃", components.o3),
            ("NO₂", components.no2)
        ]
        
        for (name, value) in componentData {
            let componentView = createComponentView(name: name, value: value)
            componentsStackView.addArrangedSubview(componentView)
        }
    }
    
    private func createComponentView(name: String, value: Double) -> UIView {
        let containerView = UIView()
        
        let nameLabel = UILabel()
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.text = name
        nameLabel.font = .systemFont(ofSize: 10, weight: .medium)
        nameLabel.textColor = .secondaryLabel
        nameLabel.textAlignment = .center
        
        let valueLabel = UILabel()
        valueLabel.translatesAutoresizingMaskIntoConstraints = false
        valueLabel.text = String(format: "%.1f", value)
        valueLabel.font = .systemFont(ofSize: 12, weight: .semibold)
        valueLabel.textColor = .label
        valueLabel.textAlignment = .center
        
        containerView.addSubview(nameLabel)
        containerView.addSubview(valueLabel)
        
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: containerView.topAnchor),
            nameLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            
            valueLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 2),
            valueLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            valueLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])
        
        return containerView
    }
    
}
