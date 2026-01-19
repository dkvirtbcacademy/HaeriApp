//
//  FormValidationManager.swift
//  Haeri
//
//  Created by kv on 18.01.26.
//

import Foundation

struct ValidationResult {
    let isValid: Bool
    let nameError: String?
    let emailError: String?
    let passwordError: String?
    let confirmPasswordError: String?
    let categoryError: String?
    
    init(
        isValid: Bool,
        nameError: String? = nil,
        emailError: String? = nil,
        passwordError: String? = nil,
        confirmPasswordError: String? = nil,
        categoryError: String? = nil
    ) {
        self.isValid = isValid
        self.nameError = nameError
        self.emailError = emailError
        self.passwordError = passwordError
        self.confirmPasswordError = confirmPasswordError
        self.categoryError = categoryError
    }
}

struct CategoryValidationResult {
    let isValid: Bool
    let categoryError: String?
}

struct FormValidationManager {
    
    func validateLogin(email: String, password: String) -> ValidationResult {
        var emailError: String?
        var passwordError: String?
        
        let trimmedEmail = email.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmedEmail.isEmpty {
            emailError = "ელ. ფოსტა სავალდებულოა"
        } else if !isValidEmail(trimmedEmail) {
            emailError = "არასწორი ელ. ფოსტის ფორმატი"
        }
        
        let trimmedPassword = password.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmedPassword.isEmpty {
            passwordError = "პაროლი სავალდებულოა"
        } else if trimmedPassword.count < 8 {
            passwordError = "პაროლი უნდა შეიცავდეს მინიმუმ 8 სიმბოლოს"
        }
        
        let isValid = emailError == nil && passwordError == nil
        
        return ValidationResult(
            isValid: isValid,
            emailError: emailError,
            passwordError: passwordError
        )
    }
    
    func validateRegistrationStepOne(
        name: String,
        email: String,
        password: String,
        confirmPassword: String
    ) -> ValidationResult {
        var nameError: String?
        var emailError: String?
        var passwordError: String?
        var confirmPasswordError: String?
        
        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmedName.isEmpty {
            nameError = "სახელი სავალდებულოა"
        } else if trimmedName.count < 2 {
            nameError = "სახელი უნდა შეიცავდეს მინიმუმ 2 სიმბოლოს"
        }
        
        let trimmedEmail = email.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmedEmail.isEmpty {
            emailError = "ელ. ფოსტა სავალდებულოა"
        } else if !isValidEmail(trimmedEmail) {
            emailError = "არასწორი ელ. ფოსტის ფორმატი"
        }
        
        let trimmedPassword = password.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmedPassword.isEmpty {
            passwordError = "პაროლი სავალდებულოა"
        } else if trimmedPassword.count < 8 {
            passwordError = "პაროლი უნდა შეიცავდეს მინიმუმ 8 სიმბოლოს"
        }
        
        let trimmedConfirmPassword = confirmPassword.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmedConfirmPassword.isEmpty {
            confirmPasswordError = "გაიმეორეთ პაროლი"
        } else if trimmedPassword != trimmedConfirmPassword {
            confirmPasswordError = "პაროლები არ ემთხვევა"
        }
        
        let isValid = nameError == nil &&
        emailError == nil &&
        passwordError == nil &&
        confirmPasswordError == nil
        
        return ValidationResult(
            isValid: isValid,
            nameError: nameError,
            emailError: emailError,
            passwordError: passwordError,
            confirmPasswordError: confirmPasswordError
        )
    }
    
    func validateRegistrationStepTwo(categories: [String]) -> CategoryValidationResult {
        if categories.isEmpty {
            return CategoryValidationResult(
                isValid: false,
                categoryError: "გთხოვთ აირჩიოთ მინიმუმ ერთი კატეგორია"
            )
        }
        
        return CategoryValidationResult(isValid: true, categoryError: nil)
    }
    
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
}
