//
//  Constant.swift
//  HelperClasses
//
//  Created by Apple on 15/12/23.
//

import UIKit

// add the aspect ratio of the device screen from your targeted figma design
let aspectRatio: CGSize = CGSize(width: 393, height: 852) // iPhone 14 Pro

var is_live: Bool {
#if DEBUG
    return false
#else
    return true
#endif
}

// SET THE FLAG TO PRINT FUNCTION IN PROJECT
var isPrintAllowed = is_live ? false : true

let noInternetConnectionErrorStatusCode : Int = 999

// CLOSURE
typealias VoidClosure = () -> Void
typealias PassStringClosure = (String) -> Void
typealias PassBoolClosure = (Bool) -> Void

typealias ApiCallFailureBinder = (_ message : String, _ statusCode: Int) -> Void

// OTHER DataTypes
typealias StringToStringDict = [String : String]
typealias StringAnyDict = [String : Any]
typealias StringAnyDictArray = [[String : Any]]

class URLConstants{
    static var test = "test"
    
    static var localFileUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    static var settingUrl = UIApplication.openSettingsURLString
    
    static var bleSettings = "App-prefs:Bluetooth"
    static var locationSettings = "App-prefs:LOCATION_SERVICES"
    
}
