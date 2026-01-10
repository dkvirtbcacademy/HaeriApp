//
//  RegisterViewController.swift
//  Haeri
//
//  Created by kv on 10.01.26.
//

import UIKit
import Combine

class RegisterViewController: UIViewController {
    private let viewModel: RegisterViewModel
    private var cancellables = Set<AnyCancellable>()
    
    private let header = UikitPageHeader(pageName: "რეგისტრაცია")
    private lazy var progressSteps = ProgressSteps(steps: viewModel.maxSteps)
    
    private let stepOne = RegistrationStepOne()
    private let stepTwo = RegistrationStepTwo()
    
    private let stepContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let button = UikitButton(label: "გაგრძელება")
    
    init(viewModel: RegisterViewModel) {
        self.viewModel = viewModel
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
    }
    
    private func setupUI() {
        setHeader()
        setStepContainer()
        setButton()
        setProgressStackView()
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
            stepContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24)
        ])
    }
    
    private func setProgressStackView() {
        view.addSubview(progressSteps)
        
        NSLayoutConstraint.activate([
            progressSteps.topAnchor.constraint(greaterThanOrEqualTo: stepContainer.bottomAnchor, constant: 20),
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
    
    private func setupActions() {
        header.onBackTapped = { [weak self] in
            self?.viewModel.navigateBack()
        }
        
        button.addAction(UIAction { [weak self] _ in
            self?.viewModel.handleButtonTap()
        }, for: .touchUpInside)
        
        bindViewModel()
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
