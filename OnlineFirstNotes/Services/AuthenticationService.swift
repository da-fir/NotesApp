//
//  AuthenticationService.swift
//  OnlineFirstNotes
//
//  Created by Darul Firmansyah on 11/01/25.
//

import LocalAuthentication

protocol AuthenticationServiceProtocol {
    func authenticateUser(completion: @escaping (Bool) -> Void)
}

final class AuthenticationService: ObservableObject, AuthenticationServiceProtocol {
    func authenticateUser(completion: @escaping (Bool) -> Void) {
        let context = LAContext()
        var error: NSError?

        // Check if the device can evaluate the policy
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Please authenticate to access your tasks."

            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in
                DispatchQueue.main.async {
                    completion(success)
                }
            }
        } else {
            // Biometrics not available, handle error
            print("Biometrics not available: \(error?.localizedDescription ?? "Unknown error")")
            completion(false)
        }
    }
}
