//
//  FontFamilly.swift
//  HelperClasses
//
//  Created by Apple on 15/12/23.
//

import UIKit


class FontFamily: NSObject{
    
    static func fontFromConstant(font: FontConstant, size: CGFloat) -> UIFont{
        return UIFont(name: font.rawValue, size: getFontSize(size: size)) ?? UIFont.systemFont(ofSize: getFontSize(size: size))
    }
    
    static private func getFontSize(size: CGFloat) -> CGFloat{
        return (UIScreen.main.bounds.width * size)/aspectRatio.width
    }
    
    enum FontConstant: String{
        // Add the fonts manually in ->  info.plist -> Fonts Provided By Application
        
        case kABC = "ABC"
        
    }
    
}
