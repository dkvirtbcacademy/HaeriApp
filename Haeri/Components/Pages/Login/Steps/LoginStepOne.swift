//
//  LoginStepOne.swift
//  Haeri
//
//  Created by kv on 10.01.26.
//

import UIKit

class LoginStepOne: UIView {
    
    private let posterView: UIImageView = {
        let poster = UIImageView()
        poster.translatesAutoresizingMaskIntoConstraints = false
        poster.image = UIImage(named: "step one poster")
        return poster
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "ჰაერის ხარისხი მნიშვნელოვანია"
        label.font = .firagoBold(.medium)
        label.textColor = UIColor(named: "TextColor")
        label.numberOfLines = 0
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "შენზე მორგებული მრჩეველი ჰაერის დაბინძურებისგან თავის დასაცავად"
        label.font = .firago(.xxsmall)
        label.textColor = UIColor(named: "TextColor")
        label.numberOfLines = 0
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    private func setupUI() {
        setPoster()
        setTitleLabel()
        setDescriptionLabel()
    }
    
    private func setPoster() {
        addSubview(posterView)
        
        NSLayoutConstraint.activate([
            posterView.topAnchor.constraint(equalTo: topAnchor),
            posterView.leadingAnchor.constraint(equalTo: leadingAnchor),
            posterView.trailingAnchor.constraint(equalTo: trailingAnchor),
            posterView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.8)
            
        ])
    }
    
    private func setTitleLabel() {
        addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: posterView.bottomAnchor, constant: 15),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
    }
    
    private func setDescriptionLabel() {
        addSubview(descriptionLabel)
        
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            descriptionLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
