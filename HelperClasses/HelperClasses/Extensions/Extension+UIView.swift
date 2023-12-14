//
//  Extension+UIView.swift
//  HelperClasses
//
//  Created by Apple on 14/12/23.
//

import UIKit

extension UIView{
    
    func applyConerRadius(cornerRadius: CGFloat, corners: CACornerMask = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMaxXMaxYCorner, .layerMinXMaxYCorner]){
        self.clipsToBounds = true
        self.layer.masksToBounds = true
        self.layer.cornerRadius = cornerRadius
        self.layer.maskedCorners = corners
    }
    
}
