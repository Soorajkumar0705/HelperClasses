//
//  Extension+String.swift
//  HelperClasses
//
//  Created by Meet Appmatictech on 25/03/24.
//

import Foundation

extension String{

    func isValidEmail() -> Bool {
        // Regular expression for a simple email validation
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"

        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)

        return emailPredicate.evaluate(with: self)
    }
    
    func isValidPhoneNumber() -> Bool {
        return self.rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil && self.count == 10
    }

    func isUppercaseIncluded() -> Bool {
        return self.rangeOfCharacter(from: .uppercaseLetters) != nil
    }

    func isLowercaseIncluded() -> Bool {
        return self.rangeOfCharacter(from: .lowercaseLetters) != nil
    }

    func isDigitIncluded() -> Bool {
        return self.rangeOfCharacter(from: .decimalDigits) != nil
    }

    func isSpecialCharacterIncluded() -> Bool {
        let specialCharacters = CharacterSet(charactersIn: "!@#$%^&*()-_=+[]{}|;:'\",.<>?/")
        return self.rangeOfCharacter(from: specialCharacters) != nil
    }
    
    func containsSpace() -> Bool {
        return self.contains(" ")
    }

    func charSeperatedAfterNumberOfChar(char: String, afterChar: Int = 2) -> String{
        var returnableText : String = ""
        
        for (index, char) in self.enumerated() {
            returnableText.append(char)
            if (index + 1) % afterChar == 0 && index != self.count - 1 {
                returnableText.append(":")
            }
        }
        return returnableText
    }   // charSeperatedAfterSomenuberOfChar
    
}
