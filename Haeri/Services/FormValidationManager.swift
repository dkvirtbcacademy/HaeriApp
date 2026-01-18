//
//  FormValidationManager.swift
//  Haeri
//
//  Created by kv on 18.01.26.
//

import Foundation

struct CreateUserValidationManager {
    func validate(_ user: UserModel) throws {
        if user.name.isEmpty {
            throw CreateValidationError.invalidName
        }
    }
}

extension CreateUserValidationManager {
    enum CreateValidationError: Error {
        case invalidName
    }
}

extension CreateUserValidationManager.CreateValidationError {
    var errorDescription: String? {
        switch self {
        case .invalidName:
            return "სახელის ველი ცარიელია"
        }
    }
}
