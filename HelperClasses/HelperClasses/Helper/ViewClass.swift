//
//  ViewClass.swift
//  HelperClasses
//
//  Created by Apple on 14/12/23.
//

import UIKit

class CornerRadiusView: UIView{
    
    @IBInspectable var cornerRadius: CGFloat = 0.0{
        didSet{
            self.applyConerRadius(cornerRadius: cornerRadius)
        }
    }
    
    @IBInspectable var isCapsuleCircle: Bool = false{
        didSet{
            if isCapsuleCircle { applyConerRadius(cornerRadius: self.frame.height/2) }
        }
    }
    
    @IBInspectable var isCylinderCircle: Bool = false{
        didSet{
            if isCylinderCircle { applyConerRadius(cornerRadius: self.frame.width/2) }
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
    override func layoutIfNeeded() {
        super.layoutIfNeeded()
        
    }
}

class CornerRadiusBorderView: CornerRadiusView{
    
    @IBInspectable var borderWidth: CGFloat = 0.0{
        didSet{
            applyBorder(borderWidth: borderWidth, borderColor: borderColor, borderOpacity: borderOpacity)
        }
    }
    
    @IBInspectable var borderColor: UIColor = .clear{
        didSet{
            applyBorder(borderWidth: borderWidth, borderColor: borderColor, borderOpacity: borderOpacity)
        }
    }
    
    @IBInspectable var borderOpacity: CGFloat = 1.0{
        didSet{
            applyBorder(borderWidth: borderWidth, borderColor: borderColor, borderOpacity: borderOpacity)
        }
    }
    
}

class CornerRadiusBorderShadowView: CornerRadiusBorderView{
    
    @IBInspectable var shadowColor: UIColor = .clear
    @IBInspectable var shadowOpacity: Float = 1.0
    @IBInspectable var shadowXOffset: CGFloat = 0
    @IBInspectable var shadowYOffset: CGFloat = 0
    @IBInspectable var shadowBlur: CGFloat = 0
    @IBInspectable var shadowSpread: CGFloat = 0
   
    override func layoutSubviews() {
        super.layoutSubviews()
        applyShadow(shadowColor: shadowColor, shadowOpacity: shadowOpacity, shadowXOffset: shadowXOffset, shadowYOffset: shadowYOffset, shadowBlur: shadowBlur, shadowSpread: shadowSpread)
    }
    
}
