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
        label.text = "მიიღე პერსონალიზებული რეკომენდაციები ჰაერის დაბინძურებისგან თავის დასაცავად. \n\n აირჩიე მინიმუმ ერთი კატეგორია:"
        label.font = .firagoMedium(.medium)
        label.textColor = UIColor(named: "TextColor")
        label.numberOfLines = 0
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.allowsMultipleSelection = true
        table.separatorStyle = .none
        table.backgroundColor = .clear
        table.isScrollEnabled = false
        return table
    }()
    
    private var selectedIndices: Set<Int> = []
    
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
        setupTableView()
    }
    
    private func setTitleLabel() {
        addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
    }
    
    private func setupTableView() {
        addSubview(tableView)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UserCategoryCell.self, forCellReuseIdentifier: "UserCategoryCell")
        
        let tableHeight = CGFloat(userCategories.count) * 65
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.heightAnchor.constraint(equalToConstant: tableHeight)
        ])
    }
    
    func getSelectedCategories() -> [String] {
        return selectedIndices.sorted().map { userCategories[$0].label }
    }
}

extension RegistrationStepTwo: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userCategories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCategoryCell", for: indexPath) as! UserCategoryCell
        let category = userCategories[indexPath.row]
        cell.configure(with: category.label, iconName: category.iconName, isSelected: selectedIndices.contains(indexPath.row))
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if selectedIndices.contains(indexPath.row) {
            selectedIndices.remove(indexPath.row)
        } else {
            selectedIndices.insert(indexPath.row)
        }
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
}
