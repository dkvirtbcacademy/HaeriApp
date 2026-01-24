//
//  RegistrationStepTwo.swift
//  Haeri
//
//  Created by kv on 10.01.26.
//

import UIKit

class RegistrationStepTwo: UIView {
    
    private var userCategories: [UserCategoryModel]
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "პერსონალიზებული რეკომენდაციების მისაღებად აირჩიე მინიმუმ ერთი კატეგორია:"
        label.font = .firagoMedium(.medium)
        label.textColor = UIColor(named: "TextColor")
        label.numberOfLines = 0
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var categoryGameView: CategoryGameView!
    
    init(userCategories: [UserCategoryModel]) {
        self.userCategories = userCategories
        super.init(frame: .zero)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        setTitleLabel()
        setupCategoryGameView()
    }
    
    private func setTitleLabel() {
        addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
    }
    
    private func setupCategoryGameView() {
        categoryGameView = CategoryGameView(userCategories: userCategories)
        categoryGameView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(categoryGameView)
        
        NSLayoutConstraint.activate([
            categoryGameView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            categoryGameView.leadingAnchor.constraint(equalTo: leadingAnchor),
            categoryGameView.trailingAnchor.constraint(equalTo: trailingAnchor),
            categoryGameView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    func getSelectedCategorySlugs() -> [String] {
        return categoryGameView.getSelectedCategorySlugs()
    }
}
