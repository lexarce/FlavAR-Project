//
//  PasswordStrength.swift
//  CapstoneProject
//
//  Created by Kaleb on 2/16/25.
//

import Foundation

//Test strength of password function
func isPasswordStrong(_ password: String) -> Bool {
    let minLength = 8
    let regex = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[!@#$%^&*]).{\(minLength),}$"
    
    let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
    return predicate.evaluate(with: password)
}
