//
//  AvatarCell.swift
//  Haeri
//
//  Created by kv on 13.01.26.
//

import UIKit

class AvatarCell: UICollectionViewCell {
    private let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.tintColor = UIColor(named: "TextColor")
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        contentView.applyLightGlass(cornerRadius: 12)
        
        contentView.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            imageView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.6),
            imageView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.6)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with avatar: String, isSelected: Bool) {
        imageView.image = UIImage(named: avatar)
        
        if isSelected {
            contentView.backgroundColor = UIColor(named: "ButtonBlue")?.withAlphaComponent(0.2)
            contentView.layer.borderWidth = 3
            contentView.layer.borderColor = UIColor(named: "ButtonBlue")?.cgColor
        } else {
            contentView.backgroundColor = .clear
            contentView.layer.borderWidth = 0.5
            contentView.layer.borderColor = UIColor.white.withAlphaComponent(0.3).cgColor
        }
    }
}
