//
//  UserDefaultsHelper.swift
//  HelperClasses
//
//  Created by Meet Appmatictech on 25/03/24.
//

import Foundation

class UserDefaultsHelper : NSObject {
    
    // Session Token based storage
    static func setSessionToken(token: String) {
        UserDefaults.standard.set(token, forKey: "sessionToken")
    }
    
    static func getSessionToken() -> String? {
        return UserDefaults.standard.value(forKey: "sessionToken") as? String
    }
    
    static func removeSessionToken() {
        UserDefaults.standard.removeObject(forKey: "sessionToken")
    }
    
    static func clearUserDefaultData() {
        for key in UserDataKeys.allCases{
            UserDefaults.standard.removeObject(forKey: key.rawValue)
        }
    }
    
    private enum UserDataKeys:String, CaseIterable{
        case sessionToken = "sessionToken"
    }
    
}
