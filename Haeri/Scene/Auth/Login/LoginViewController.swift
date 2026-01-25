//
//  LoginViewController.swift
//  Haeri
//
//  Created by kv on 05.01.26.
//

import UIKit
import SwiftUI
import Combine

class LoginViewController: UIViewController, UIKitAlertHandler {
    private let viewModel: LoginViewModel
    private let formValidationManager: FormValidationManager
    private var cancellables = Set<AnyCancellable>()
    private let button = UikitButton(label: "დაწყება")
    
    private let stepOne = LoginStepOne()
    private let stepTwo = LoginStepTwo()
    
    private lazy var progressSteps = ProgressSteps(steps: viewModel.maxSteps)
    
    private let stepContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let logiView: UIImageView = {
        let logo = UIImageView()
        logo.contentMode = .scaleAspectFit
        logo.translatesAutoresizingMaskIntoConstraints = false
        logo.image = UIImage(named: "Haeri Logo")
        return logo
    }()
    
    private lazy var loadingHostingController: UIHostingController<ExpandingRings> = {
        let loadingView = ExpandingRings()
        let hostingController = UIHostingController(rootView: loadingView)
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        hostingController.view.backgroundColor = .clear
        hostingController.view.isHidden = true
        return hostingController
    }()
    
    init(viewModel: LoginViewModel, formValidationManager: FormValidationManager) {
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
        setupFieldObservers()
        setupKeyboardHandling()
        observeLoadingState()
    }
    
    private func setupUI() {
        setupLogo()
        setButton()
        setProgressStackView()
        setupStepContainer()
        setupLoadingView()
    }
    
    private func setupLoadingView() {
        addChild(loadingHostingController)
        view.addSubview(loadingHostingController.view)
        loadingHostingController.didMove(toParent: self)
        
        NSLayoutConstraint.activate([
            loadingHostingController.view.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingHostingController.view.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            loadingHostingController.view.widthAnchor.constraint(equalToConstant: 60),
            loadingHostingController.view.heightAnchor.constraint(equalToConstant: 60),
        ])
    }
    
    private func setupFieldObservers() {
        stepTwo.mailField.onTextChanged = { [weak self] _ in
            self?.validateAndClearEmailError()
        }
        
        stepTwo.passwordField.onTextChanged = { [weak self] _ in
            self?.validateAndClearPasswordError()
        }
    }
    
    private func validateAndClearEmailError() {
        let email = stepTwo.mailField.getInputText() ?? ""
        let password = stepTwo.passwordField.getInputText() ?? ""
        
        let result = formValidationManager.validateLogin(email: email, password: password)
        
        if result.emailError == nil {
            stepTwo.mailField.clearError()
        }
    }
    
    private func validateAndClearPasswordError() {
        let email = stepTwo.mailField.getInputText() ?? ""
        let password = stepTwo.passwordField.getInputText() ?? ""
        
        let result = formValidationManager.validateLogin(email: email, password: password)
        
        if result.passwordError == nil {
            stepTwo.passwordField.clearError()
        }
    }
    
    private func setupActions() {
        bindViewModel()
        
        stepTwo.registerTapped = { [weak self] in
            self?.viewModel.navigateToRegister()
        }
        
        viewModel.authManager.$authError
            .compactMap { $0 }
            .sink { [weak self] error in
                self?.handleAuthError(error)
                self?.viewModel.authManager.authError = nil
            }
            .store(in: &cancellables)
    }
    
    private func observeLoadingState() {
        viewModel.authManager.$isLoading
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isLoading in
                guard let self = self else { return }
                
                if isLoading {
                    self.loadingHostingController.view.isHidden = false
                    self.button.isEnabled = false
                    self.button.alpha = 0.5
                    self.stepTwo.mailField.isUserInteractionEnabled = false
                    self.stepTwo.passwordField.isUserInteractionEnabled = false
                } else {
                    self.loadingHostingController.view.isHidden = true
                    self.button.isEnabled = true
                    self.button.alpha = 1.0
                    self.stepTwo.mailField.isUserInteractionEnabled = true
                    self.stepTwo.passwordField.isUserInteractionEnabled = true
                }
            }
            .store(in: &cancellables)
    }
    
    private func setupLogo() {
        view.addSubview(logiView)
        
        NSLayoutConstraint.activate([
            logiView.topAnchor.constraint(equalTo: view.topAnchor, constant: 75),
            logiView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    private func setupStepContainer() {
        view.addSubview(stepContainer)
        
        NSLayoutConstraint.activate([
            stepContainer.topAnchor.constraint(equalTo: logiView.bottomAnchor, constant: 30),
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
        button.addAction(UIAction { [weak self] _ in
            guard let self = self else { return }
            
            if self.viewModel.currentStep == 1 {
                self.viewModel.moveToNextStep()
                return
            }
            
            if self.viewModel.currentStep == 2 {
                guard self.captureUserData() else { return }
                
                Task { @MainActor in
                    await self.viewModel.handleButtonTap()
                }
            }
        }, for: .touchUpInside)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(button)
        
        NSLayoutConstraint.activate([
            button.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -40),
            button.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            button.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    @discardableResult
    private func captureUserData() -> Bool {
        let email = stepTwo.mailField.getInputText() ?? ""
        let password = stepTwo.passwordField.getInputText() ?? ""
        
        let result = formValidationManager.validateLogin(email: email, password: password)
        
        if let emailError = result.emailError {
            stepTwo.mailField.setError(emailError)
        } else {
            stepTwo.mailField.clearError()
        }
        
        if let passwordError = result.passwordError {
            stepTwo.passwordField.setError(passwordError)
        } else {
            stepTwo.passwordField.clearError()
        }
        
        if result.isValid {
            viewModel.userEmail = email.trimmingCharacters(in: .whitespacesAndNewlines)
            viewModel.userPassword = password.trimmingCharacters(in: .whitespacesAndNewlines)
            return true
        }
        
        return false
    }
    
    func clearErrors() {
        stepTwo.mailField.clearError()
        stepTwo.passwordField.clearError()
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
            newStepView = stepOne
        case 2:
            newStepView = stepTwo
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
