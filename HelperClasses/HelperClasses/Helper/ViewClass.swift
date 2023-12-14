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
