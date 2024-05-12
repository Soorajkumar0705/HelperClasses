//
//  Extension+Other.swift
//  HelperClasses
//
//  Created by Apple on 10/02/24.
//

import UIKit

extension NSObject {
    var className: String {
        return String(describing: type(of: self))
    }

    class var className: String {
        return String(describing: self)
    }
}

extension UIApplication {
    static var release: String {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String? ?? "x.x"
    }
    static var build: String {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as! String? ?? "x"
    }
    static var version: String {
        return "\(release).\(build)"
    }
}

extension Bool{
    
    mutating func toggle(){
        self = !self
    }
    
}

extension Int {

    func toInt32() -> Int32{
        return Int32(self)
    }

}

extension Int32 {

    func toInt() -> Int{
        return Int(self)
    }

}

extension Double{
    
    func toInt() -> Int{
        return Int(self)
    }
}

extension String{
    
    func toUInt8() -> UInt8?{
        UInt8(self)
    }
    
    func toInt() -> Int?{
        return Int(self)
    }
    
    func toDouble() -> Double?{
        return Double(self)
    }
    
}

extension String.SubSequence{
    
    func toString() -> String{
       return String(self)
    }
    
}

// Below function provide the ornial of the number
// EX :- "1" -> "1st", "2" -> "2nd", "3" -> "3rd", "4" -> "4th"

extension String {
    var ordinal: String {
        switch self {
        case "1", "21", "31": return "\(self)st"
        case "2", "22": return "\(self)nd"
        case "3", "23": return "\(self)rd"
        default: return "\(self)th"
        }
    }
}

// Notification

extension NSObject {
    
    func addNotification(name : Notification.Name, object : Any? = nil , getNotification : @escaping (Notification) -> Void ){
        NotificationCenter.default.addObserver(forName: name, object: nil, queue: .main, using: { [weak self] notification in
            guard let self else { return }
            getNotification(notification)
        })
    }
    
    func addNotification(name : String, object : Any? = nil , getNotification : @escaping (Notification) -> Void ){
        NotificationCenter.default.addObserver(forName: Notification.Name(rawValue: name), object: nil, queue: .main, using: { [weak self] notification in
            guard let self else { return }
            getNotification(notification)
        })
    }
    
}

func postNotification(name : Notification.Name, object : Any? = nil){
    NotificationCenter.default.post(name: name, object: object)
}

func postNotification(name : String, object : Any? = nil){
    NotificationCenter.default.post(name: Notification.Name(rawValue: name), object: object)
}

extension Notification.Name {
    
    struct PopUpClickNotifications{
    }
    
    struct Locations{
        static let didUpdatedPlaceMark = Notification.Name("Locations+didUpdatedPlaceMark")
    }
}

extension Data{
    
    func toImage() -> UIImage?{
        return UIImage(data: self)
    }
    
    func toString(encoding : String.Encoding = .utf8) -> String?{
        String(data: self, encoding: encoding)?.replacingOccurrences(of: "\0", with: "")
    }
    
    /*
     Example -
     let value: Data = Data()
     
     value.convertToValue(type : Int8.self)
     value.convertToValue(type : Int16.self)
     value.convertToValue(type : Int32.self)
     value.convertToValue(type : Float.self)
     value.convertToValue(type : Double.self)
     value.convertToValue(type : String.self)
     
    */
    
    func convertToValue<T: LosslessStringConvertible>(type: T.Type = Int8.self) -> T? {
           if self.count == 0 && self.isEmpty {
               print("There is no data to convert to \(T.self)")
               return nil
           }
           
           if type == Float.self || type == Double.self {
               guard self.count == MemoryLayout<T>.size else {
                   print("Data size does not match the size of \(T.self)")
                   return nil
               }
           } else {
               guard self.count >= MemoryLayout<T>.size else {
                   print("Data size is insufficient to represent \(T.self).")
                   return nil
               }
           }
           
           return self.withUnsafeBytes { $0.load(as: T.self) }
       }

}

// DATES
fileprivate var dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"
    return formatter
}()

extension Date {
    
    static func getCurrentDateInString() -> String {
        let currentDate = Date()
        let formattedDate = dateFormatter.string(from: currentDate)
        return formattedDate
    }
    
    static func getCurrentDate() -> Date? {
        return dateFormatter.date(from: getCurrentDateInString())
    }
    
    static func getDiffrecefromDateToDate(from date1 : Date = getCurrentDate() ?? Date(), to date2 : Date) -> TimeInterval{
        return date2.timeIntervalSince(date1)
    }
    
    func diffrenceFromCurrentDate() -> DateComponents{
        Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: self, to: Date())
    }
    
    static func diffrenceOfDates(from startDate: Date, to endDate: Date) -> DateComponents{
        Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: endDate, to: startDate)
    }
    
}

extension String {
    func toDate() -> Date?{
        dateFormatter.date(from: self)
    }
}

extension TimeInterval {
    
    func toDays() -> Int{
        let value = self / (60 * 60 * 24)
        return Int( ((-1.0..<0.0) ~= value) ? -1 : value)
    }
    
    func toHours() -> Int{
        Int(self.truncatingRemainder(dividingBy: (60 * 60 * 24)) / (60 * 60))
    }
    
    func toMinutes() -> Int{
        Int(self.truncatingRemainder(dividingBy: (60 * 60)) / 60)
    }
    
    func toSeconds() -> Int{
        Int(self.truncatingRemainder(dividingBy: 60))
    }
    
}
