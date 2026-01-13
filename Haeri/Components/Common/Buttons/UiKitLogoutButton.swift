//
//  UiKitLogoutButton.swift
//  Haeri
//
//  Created by kv on 12.01.26.
//

import UIKit

class UiKitLogoutButton: UIButton {

    init() {
        super.init(frame: .zero)
        
        setTitle("გამოსვლა", for: .normal)
        titleLabel?.font = .firagoMedium(.xmedium)
        setTitleColor(UIColor(named: "TextColor"), for: .normal)
        layer.cornerRadius = 25
        backgroundColor = UIColor(named: "LogoutRed")
        
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowRadius = 4
        layer.shadowOpacity = 0.1
        layer.masksToBounds = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(label: String) {
        setTitle(label, for: .normal)
    }

}
