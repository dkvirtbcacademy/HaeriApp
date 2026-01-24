//
//  RegisterViewController.swift
//  Haeri
//
//  Created by kv on 10.01.26.
//

import UIKit
import Combine

class RegisterViewController: UIViewController, UIKitAlertHandler {
    private let viewModel: RegisterViewModel
    private let formValidationManager: FormValidationManager
    private var cancellables = Set<AnyCancellable>()
    
    private let header = UikitPageHeader(pageName: "რეგისტრაცია")
    private lazy var progressSteps = ProgressSteps(steps: viewModel.maxSteps)
    
    private let stepOne = RegistrationStepOne()
    private lazy var stepTwo = RegistrationStepTwo(userCategories: viewModel.getUserCategories())
    
    private let stepContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let button = UikitButton(label: "გაგრძელება")
    
    init(viewModel: RegisterViewModel, formValidationManager: FormValidationManager) {
        self.viewModel = viewModel
        self.formValidationManager = formValidationManager
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addAdaptiveBackground(value: 1)
        setupUI()
        setupActions()
        setupKeyboardHandling()
        setupFieldObservers()
    }
    
    private func setupUI() {
        setHeader()
        setButton()
        setProgressStackView()
        setStepContainer()
    }
    
    private func setHeader() {
        header.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(header)
        
        NSLayoutConstraint.activate([
            header.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            header.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            header.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            header.heightAnchor.constraint(equalToConstant: 56)
        ])
    }
    
    private func setStepContainer() {
        view.addSubview(stepContainer)
        
        NSLayoutConstraint.activate([
            stepContainer.topAnchor.constraint(equalTo: header.bottomAnchor, constant: 30),
            stepContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            stepContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            stepContainer.bottomAnchor.constraint(equalTo: progressSteps.topAnchor, constant: -20)
        ])
    }
    
    private func setProgressStackView() {
        view.addSubview(progressSteps)
        
        NSLayoutConstraint.activate([
            progressSteps.bottomAnchor.constraint(equalTo: button.topAnchor, constant: -30),
            progressSteps.heightAnchor.constraint(equalToConstant: 3),
            progressSteps.widthAnchor.constraint(equalToConstant: 80),
            progressSteps.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    private func setButton() {
        button.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(button)
        
        NSLayoutConstraint.activate([
            button.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            button.heightAnchor.constraint(equalToConstant: 50),
            button.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -40)
        ])
    }
    
    private func setupFieldObservers() {
        stepOne.nameField.onTextChanged = { [weak self] _ in
            self?.validateAndClearFieldError(\.nameError, field: self?.stepOne.nameField)
        }
        
        stepOne.mailField.onTextChanged = { [weak self] _ in
            self?.validateAndClearFieldError(\.emailError, field: self?.stepOne.mailField)
        }
        
        stepOne.passwordField.onTextChanged = { [weak self] _ in
            self?.validateAndClearFieldError(\.passwordError, field: self?.stepOne.passwordField)
            self?.validateAndClearFieldError(\.confirmPasswordError, field: self?.stepOne.confirmPasswordField)
        }
        
        stepOne.confirmPasswordField.onTextChanged = { [weak self] _ in
            self?.validateAndClearFieldError(\.confirmPasswordError, field: self?.stepOne.confirmPasswordField)
        }
    }
    
    private func validateAndClearFieldError(_ keyPath: KeyPath<ValidationResult, String?>, field: Any?) {
        let result = formValidationManager.validateRegistrationStepOne(
            name: stepOne.nameField.getInputText() ?? "",
            email: stepOne.mailField.getInputText() ?? "",
            password: stepOne.passwordField.getInputText() ?? "",
            confirmPassword: stepOne.confirmPasswordField.getInputText() ?? ""
        )
        
        if result[keyPath: keyPath] == nil {
            if let nameField = field as? NameField {
                nameField.clearError()
            } else if let passwordField = field as? PasswordField {
                passwordField.clearError()
            }
        }
    }
    
    private func setupActions() {
        header.onBackTapped = { [weak self] in
            self?.viewModel.navigateBack()
        }
        
        button.addAction(UIAction { [weak self] _ in
            guard let self else { return }
            
            if self.viewModel.currentStep == 1 {
                guard self.captureStepTwoData() else {
                    return
                }
                self.viewModel.moveToNextStep()
            } else if self.viewModel.currentStep == 2 {
                guard self.captureStepOneData() else {
                    return
                }
                Task { @MainActor in
                    await self.viewModel.handleButtonTap()
                }
            }
            
        }, for: .touchUpInside)
        
        bindViewModel()
        
        viewModel.authManager.$authError
            .compactMap { $0 }
            .sink { [weak self] error in
                self?.handleAuthError(error)
                self?.viewModel.authManager.authError = nil
            }
            .store(in: &cancellables)
    }
    
    private func captureStepOneData() -> Bool {
        let name = stepOne.nameField.getInputText() ?? ""
        let email = stepOne.mailField.getInputText() ?? ""
        let password = stepOne.passwordField.getInputText() ?? ""
        let confirmPassword = stepOne.confirmPasswordField.getInputText() ?? ""
        
        let result = formValidationManager.validateRegistrationStepOne(
            name: name,
            email: email,
            password: password,
            confirmPassword: confirmPassword
        )
        
        if let nameError = result.nameError {
            stepOne.nameField.setError(nameError)
        } else {
            stepOne.nameField.clearError()
        }
        
        if let emailError = result.emailError {
            stepOne.mailField.setError(emailError)
        } else {
            stepOne.mailField.clearError()
        }
        
        if let passwordError = result.passwordError {
            stepOne.passwordField.setError(passwordError)
        } else {
            stepOne.passwordField.clearError()
        }
        
        if let confirmPasswordError = result.confirmPasswordError {
            stepOne.confirmPasswordField.setError(confirmPasswordError)
        } else {
            stepOne.confirmPasswordField.clearError()
        }
        
        if result.isValid {
            viewModel.userName = name.trimmingCharacters(in: .whitespacesAndNewlines)
            viewModel.userEmail = email.trimmingCharacters(in: .whitespacesAndNewlines)
            viewModel.userPassword = password.trimmingCharacters(in: .whitespacesAndNewlines)
            return true
        }
        
        return false
    }
    
    @discardableResult
    private func captureStepTwoData() -> Bool {
        let selectedCategories = stepTwo.getSelectedCategorySlugs()
        
        let result = formValidationManager.validateRegistrationStepTwo(categories: selectedCategories)
        
        if result.isValid {
            viewModel.userCategory = selectedCategories
            return true
        } else {
            if let error = result.categoryError {
                showAlert(UIKitAlertItem(title: "შეცდომა", message: error))
            }
            return false
        }
    }
    
    func clearErrors() {
        stepOne.nameField.clearError()
        stepOne.mailField.clearError()
        stepOne.passwordField.clearError()
        stepOne.confirmPasswordField.clearError()
    }
    
    private func bindViewModel() {
        viewModel.$currentStep
            .sink { [weak self] currentStep in
                self?.updateStepView(for: currentStep)
                self?.progressSteps.updateProgress(currentStep: currentStep)
            }
            .store(in: &cancellables)
        
        viewModel.$buttonTitle
            .sink { [weak self] title in
                self?.button.configure(label: title)
            }
            .store(in: &cancellables)
    }
    
    private func updateStepView(for currentStep: Int) {
        let newStepView: UIView
        
        switch currentStep {
        case 1:
            newStepView = stepTwo
        case 2:
            newStepView = stepOne
        default:
            return
        }
        
        let shouldAnimate = !stepContainer.subviews.isEmpty
        showStep(newStepView, animated: shouldAnimate)
    }
    
    private func showStep(_ stepView: UIView, animated: Bool = false) {
        let oldStepView = stepContainer.subviews.first
        
        stepView.translatesAutoresizingMaskIntoConstraints = false
        stepView.alpha = animated ? 0 : 1
        stepContainer.addSubview(stepView)
        
        NSLayoutConstraint.activate([
            stepView.topAnchor.constraint(equalTo: stepContainer.topAnchor),
            stepView.leadingAnchor.constraint(equalTo: stepContainer.leadingAnchor),
            stepView.trailingAnchor.constraint(equalTo: stepContainer.trailingAnchor),
            stepView.bottomAnchor.constraint(equalTo: stepContainer.bottomAnchor)
        ])
        
        if animated {
            UIView.animate(withDuration: 0.3, animations: {
                oldStepView?.alpha = 0
                stepView.alpha = 1
            }) { _ in
                oldStepView?.removeFromSuperview()
            }
        } else {
            oldStepView?.removeFromSuperview()
        }
    }
}
