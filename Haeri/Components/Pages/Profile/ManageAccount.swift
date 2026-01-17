//
//  ManageAccount.swift
//  Haeri
//
//  Created by kv on 12.01.26.
//

import UIKit

class ManageAccount: UIView {
    
    var changeNameTapped: (() -> Void)?
    var changePasswordTapped: (() -> Void)?
    var changeAvatarTapped: (() -> Void)?
    var changeCategoryTapped: (() -> Void)?
    var removeAccountTapped: (() -> Void)?
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "მართე ექაუნთი"
        label.font = .firagoBold(.medium)
        label.textColor = UIColor(named: "DarkText")
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "შეცვალე შენი ანგარიშის პარამეტრები"
        label.font = .firago(.small)
        label.textColor = UIColor(named: "SecondaryDarkText")
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let containerStackView: UIStackView = {
        let stackview = UIStackView()
        stackview.axis = .vertical
        stackview.spacing = 4
        stackview.distribution = .fill
        stackview.translatesAutoresizingMaskIntoConstraints = false
        return stackview
    }()
    
    private lazy var changeNameCard = createActionCard(
        icon: "person.circle.fill",
        title: "სახელის შეცვლა",
        subtitle: "განაახლე სახელი"
    )
    
    private lazy var changePasswordCard = createActionCard(
        icon: "lock.shield.fill",
        title: "პაროლის შეცვლა",
        subtitle: "უსაფრთხოების გაძლიერება"
    )
    
    private lazy var changeAvatarCard = createActionCard(
        icon: "photo.circle.fill",
        title: "ავატარის შეცვლა",
        subtitle: "შეცვალე პროფილის სურათი"
    )
    
    private lazy var changeCategoryCard = createActionCard(
        icon: "tag.circle.fill",
        title: "კატეგორიის შეცვლა",
        subtitle: "აირჩიე შენთვის სასურველი კატეგორია"
    )
    
    private let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "SecondaryDarkText")?.withAlphaComponent(0.3)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var removeAccountCard = createActionCard(
        icon: "trash.circle.fill",
        title: "ანგარიშის წაშლა",
        subtitle: "სამუდამოდ წაშალე შენი ანგარიში",
        isDestructive: true
    )

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layer.cornerRadius = 20
        clipsToBounds = true
        
        applyMediumGlass()
        setupUI()
        setActions()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        setHeader()
        setContainer()
        setSeparator()
    }
    
    private func setHeader() {
        addSubview(titleLabel)
        addSubview(subtitleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 24),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
            
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            subtitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            subtitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24)
        ])
    }
    
    private func setContainer() {
        addSubview(containerStackView)
        
        containerStackView.addArrangedSubview(changeNameCard)
        containerStackView.addArrangedSubview(changePasswordCard)
        containerStackView.addArrangedSubview(changeAvatarCard)
        containerStackView.addArrangedSubview(changeCategoryCard)
        
        NSLayoutConstraint.activate([
            containerStackView.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 15),
            containerStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            containerStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            containerStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -24)
        ])
    }
    
    private func setSeparator() {
        containerStackView.addArrangedSubview(separatorView)
        containerStackView.addArrangedSubview(removeAccountCard)
        
        NSLayoutConstraint.activate([
            separatorView.heightAnchor.constraint(equalToConstant: 1)
        ])
    }
    
    private func setActions() {
        changeNameCard.button.addAction(
            UIAction { [weak self] _ in
                self?.changeNameTapped?()
            },
            for: .touchUpInside
        )
        
        changePasswordCard.button.addAction(
            UIAction { [weak self] _ in
                self?.changePasswordTapped?()
            },
            for: .touchUpInside
        )
        
        changeAvatarCard.button.addAction(
            UIAction { [weak self] _ in
                self?.changeAvatarTapped?()
            },
            for: .touchUpInside
        )
        
        changeCategoryCard.button.addAction(
            UIAction { [weak self] _ in
                self?.changeCategoryTapped?()
            },
            for: .touchUpInside
        )
        
        removeAccountCard.button.addAction(
            UIAction { [weak self] _ in
                self?.removeAccountTapped?()
            },
            for: .touchUpInside
        )
    }
    
    private func createActionCard(icon: String, title: String, subtitle: String, isDestructive: Bool = false) -> ActionCardView {
        let card = ActionCardView(
            icon: icon,
            title: title,
            subtitle: subtitle,
            isDestructive: isDestructive
        )
        card.translatesAutoresizingMaskIntoConstraints = false
        return card
    }
}
