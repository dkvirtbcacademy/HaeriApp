//
//  CitySearchCell.swift
//  Haeri
//
//  Created by kv on 16.01.26.
//

import UIKit

class CitySearchCell: UITableViewCell {
    
    static let identifier = "CitySearchCell"
    
    private let cityNameLabel: UILabel = {
        let label = UILabel()
        label.font = .firagoMedium(.medium)
        label.textColor = .darkText
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let countryLabel: UILabel = {
        let label = UILabel()
        label.font = .firagoMedium(.small)
        label.textColor = .secondaryDarkText
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.addSubview(cityNameLabel)
        contentView.addSubview(countryLabel)
        
        NSLayoutConstraint.activate([
            cityNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            cityNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            cityNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            countryLabel.topAnchor.constraint(equalTo: cityNameLabel.bottomAnchor, constant: 4),
            countryLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            countryLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            countryLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12)
        ])
    }
    
    func configure(with city: GeoResponse) {
        cityNameLabel.text = city.local_names?.ka ?? city.name
        
        var locationParts: [String] = []
        locationParts.append(city.country)
        
        countryLabel.text = locationParts.joined(separator: ", ")
    }
}
