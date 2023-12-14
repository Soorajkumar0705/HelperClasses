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
    
    func applyBorder(borderWidth: CGFloat = 0.0, borderColor: UIColor = .clear, borderOpacity: CGFloat = 1.0){
        self.clipsToBounds = true
        self.layer.masksToBounds = true
        self.layer.borderWidth = borderWidth
        self.layer.borderColor = borderColor.withAlphaComponent(borderOpacity).cgColor
        
    }
    
    // Function to apply shadow
    func applyShadow(shadowColor: UIColor = .clear, shadowOpacity: Float = 1.0, shadowXOffset: CGFloat = 0, shadowYOffset: CGFloat = 0, shadowBlur: CGFloat = 0, shadowSpread: CGFloat = 0) {
        layer.masksToBounds = false  // Set to false to allow the shadow to be visible outside the corner radius
        
        layer.shadowColor = shadowColor.cgColor
        layer.shadowOpacity = shadowOpacity
        layer.shadowOffset = CGSize(width: shadowXOffset, height: shadowYOffset)
        layer.shadowRadius = shadowBlur / 2.0
        
        // Calculate the spread for the rounded path
        let spread = max(0, shadowSpread)
        
        // Set the shadow path to the rounded path with spread
        let roundedRect = bounds.insetBy(dx: -spread, dy: -spread)
        layer.shadowPath = UIBezierPath(roundedRect: roundedRect, cornerRadius: layer.cornerRadius).cgPath
    }
}
