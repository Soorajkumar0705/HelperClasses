//
//  ComonFunctions.swift
//  HelperClasses
//
//  Created by Apple on 10/02/24.
//

import UIKit
import AudioToolbox

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
 
}


