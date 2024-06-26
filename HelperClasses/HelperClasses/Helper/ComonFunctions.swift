//
//  ComonFunctions.swift
//  HelperClasses
//
//  Created by Apple on 10/02/24.
//

import UIKit
import AudioToolbox


//BLOCKED THE PRINT STATEMENTS FROM ALL OVER THE PROJECT

func print(_ items: Any..., separator: String = " ", terminator: String = "\n") {
    // IF PRINT ALLOWED THEN ONLY WILL THE PRINT STATEMENET WORK ELSE NOT PRINT ANYTHING
    if isPrintAllowed{
        items.forEach {
            Swift.print($0, separator: separator, terminator: terminator)
        }
    }
}

class ComonFunctions : NSObject{
    static func getAttributedText(text: String = "", attributedString : NSMutableAttributedString? = nil, range: NSRange? = nil, textColor: UIColor? = nil, textColorOpacity: CGFloat = 1, backgroundColor: UIColor? = nil, font: UIFont? = nil, underLineStyle: NSUnderlineStyle? = nil, underLineColor: UIColor? = nil, underLineColorOpacity: CGFloat = 1, shadow: NSShadow? = nil) -> NSMutableAttributedString {

        var attributes: [NSAttributedString.Key: Any] = [:]
        var tempAttributedString = NSMutableAttributedString(string: text)
        if let attributedString {
            tempAttributedString = attributedString
        }

        if let textColor = textColor {
            attributes[NSAttributedString.Key.foregroundColor] = textColor.withAlphaComponent(textColorOpacity)
        }

        if let backgroundColor = backgroundColor {
            attributes[NSAttributedString.Key.backgroundColor] = backgroundColor
        }

        if let font = font {
            attributes[NSAttributedString.Key.font] = font
        }

        if let underLineStyle = underLineStyle {
            attributes[NSAttributedString.Key.underlineStyle] = NSNumber(value: underLineStyle.rawValue)
        }

        if let underLineColor = underLineColor {
            attributes[NSAttributedString.Key.underlineColor] = underLineColor.withAlphaComponent(underLineColorOpacity)
        }

        if let shadow = shadow {
            attributes[NSAttributedString.Key.shadow] = shadow
        }

        if let range = range {
            tempAttributedString.addAttributes(attributes, range: range)
        } else {
            tempAttributedString.addAttributes(attributes, range: NSRange(location: 0, length: tempAttributedString.length))
        }

        return tempAttributedString
    }

    static func vibrate(){
        AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
    }
    
    static func generateHapticFeedback(value : UINotificationFeedbackGenerator.FeedbackType = .success){
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
    }
    
    static func playSystemSound(soundId: Int){  // 1006
        AudioServicesPlaySystemSound(SystemSoundID(soundId))
    }

    static func isNetworkAvailable() -> Bool{
        return (Network.reachability?.status != .unreachable) && (Network.reachability?.status != .none)
    }
    
    static func openWebUrl(urlString: String, with options : [UIApplication.OpenExternalURLOptionsKey : Any] = [:], completion: PassBoolClosure? = nil, getError: PassStringClosure? = nil){
        guard let url = URL(string: urlString) else {
            getError?("Not a valid url.")
            return
        }
        UIApplication.shared.open(url, options: options, completionHandler: completion)
    }
    
    static func encodeData<T:Codable>(data : T) -> Data?{
        do{
            return try JSONEncoder().encode(data)
        }catch let error{
            print("Error found ehile encoding ",error)
        }
        return nil
    }
    
    static func decodeData<T: Codable>(type : T.Type, data: Data) -> T?{
        do{
            return try JSONDecoder().decode(T.self, from: data)
        }catch let error{
            print("Error found ehile encoding ",error)
        }
        return nil
    }
    
    static func getImageDataFromURL(urlString : String, onSuccess: ((Data) -> Void)? = nil, onFailure : PassStringClosure? = nil){
        guard let url = URL(string: urlString) else {
            print("Not found a valid URL in",#function )
            return
        }
        
        DispatchQueue.global(qos: .background).async {
            
            do{
                let data = try Data(contentsOf: url)
                DispatchQueue.main.async {
                    onSuccess?(data)
                }
                
            }catch let error{
                print("Found error \(error) in URL Data in ",#function)
                onFailure?("Some Error occurred.")
            }
        }
    }   // getImageDataFromURL
    
    static func getImageDataFromURL(url : URL, onSuccess: ((Data) -> Void)? = nil, onFailure : PassStringClosure? = nil){
        
        DispatchQueue.global(qos: .background).async {
            
            do{
                let data = try Data(contentsOf: url)
                onSuccess?(data)
                
            }catch let error{
                print("Found error \(error) in URL Data in ",#function)
                onFailure?("Some Error occurred.")
            }
        }
    }   // getImageDataFromURL
    
    static func getTimeFormat() -> TimeFormat{
        let locale = NSLocale.current
        let formatter : String = DateFormatter.dateFormat(fromTemplate: "j", options:0, locale:locale)!
        if formatter.contains("a") {
            return ._12hr
        } else {
            return ._24hr
        }
    }
    
}

//MARK: - Unit Conversion

struct UnitConversion {
    
    static func kmToMiles(km value: Double) -> Double{
        return value*0.62137191
    }
    
    static func metersToKilometers(meters: Int) -> Double {
        return Double(meters) / 1000.0
    }
    
    static func secondsToMinutes(sec seconds: Int) -> Double{
        Double(seconds)/60
    }
    
    static func minutesToHours(min minutes: Int) -> Double{
        Double(minutes)/60
    }
    
    static func secondsToHours(sec seconds : Int) -> Double{
        Double(seconds)/3600
    }
    
    static func secondsToHoursMinutesSeconds(_ seconds: Int) -> (Int, Int, Int) {
        return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }
    
}
