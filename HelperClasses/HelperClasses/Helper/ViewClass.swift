//
//  ViewClass.swift
//  HelperClasses
//
//  Created by Apple on 14/12/23.
//

import UIKit

class ABCLabel:UILabel{
    override func awakeFromNib() {
        super.awakeFromNib()
        self.font = FontFamily.fontFromConstant(font: FontFamily.FontConstant.kABC, size: self.font.pointSize)
    }
}

class CornerRadiusView: UIView{

    @IBInspectable private var cornerRadius: CGFloat = 0.0
    @IBInspectable private var isCapsuleCircle: Bool = false
    @IBInspectable private var isCylinderCircle: Bool = false
    @IBInspectable private var x0y0 : Bool = false
    @IBInspectable private var x1y0 : Bool = false
    @IBInspectable private var x1y1 : Bool = false
    @IBInspectable private var x0y1 : Bool = false
    
    private func applySpecificCornerRadius(){
        var corners: CACornerMask = []
        
        if x0y0{
            corners.insert(.layerMinXMinYCorner)
        }
        
        if x1y0{
            corners.insert(.layerMaxXMinYCorner)
        }
        
        if x1y1{
            corners.insert(.layerMaxXMaxYCorner)
        }
        
        if x0y1{
            corners.insert(.layerMinXMaxYCorner)
        }
        
        if corners.isEmpty{
            corners = [.layerMinXMinYCorner,
                       .layerMaxXMinYCorner,
                       .layerMaxXMaxYCorner,
                       .layerMinXMaxYCorner]
        }
        applyCornerRadius(cornerRadius: cornerRadius, corners: corners)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if isCapsuleCircle{
            applyCornerRadius(cornerRadius: self.frame.height/2)
            
        }else if isCylinderCircle{
            applyCornerRadius(cornerRadius: self.frame.width/2)
            
        }else{
            self.applySpecificCornerRadius()
        }
    }
}

class CornerRadiusBorderView: CornerRadiusView{
    
    @IBInspectable private var borderWidth: CGFloat = 0.0
    @IBInspectable private var borderColor: UIColor = .clear
    @IBInspectable private var borderOpacity: CGFloat = 1.0

    override func awakeFromNib() {
        super.awakeFromNib()
        applyBorder(borderWidth: borderWidth, borderColor: borderColor, borderOpacity: borderOpacity)
    }
    
}

class CornerRadiusBorderShadowView: CornerRadiusBorderView{
    
    @IBInspectable private var shadowColor: UIColor = .clear
    @IBInspectable private var shadowOpacity: Float = 1.0
    @IBInspectable private var shadowXOffset: CGFloat = 0
    @IBInspectable private var shadowYOffset: CGFloat = 0
    @IBInspectable private var shadowBlur: CGFloat = 0
    @IBInspectable private var shadowSpread: CGFloat = 0
   
    override func layoutSubviews() {
        super.layoutSubviews()
        applyShadow(shadowColor: shadowColor, shadowOpacity: shadowOpacity, shadowXOffset: shadowXOffset, shadowYOffset: shadowYOffset, shadowBlur: shadowBlur, shadowSpread: shadowSpread)
    }
    
}



//MARK: - Custom UIButton

class CornerRadiusButton: UIButton{
    
    @IBInspectable private var cornerRadius: CGFloat = 0.0
    @IBInspectable private var isCapsuleCircle: Bool = false
    @IBInspectable private var isCylinderCircle: Bool = false
    @IBInspectable private var x0y0 : Bool = false
    @IBInspectable private var x1y0 : Bool = false
    @IBInspectable private var x1y1 : Bool = false
    @IBInspectable private var x0y1 : Bool = false
    
    private func applySpecificCornerRadius(){
        var corners: CACornerMask = []
        
        if x0y0{
            corners.insert(.layerMinXMinYCorner)
        }
        
        if x1y0{
            corners.insert(.layerMaxXMinYCorner)
        }
        
        if x1y1{
            corners.insert(.layerMaxXMaxYCorner)
        }
        
        if x0y1{
            corners.insert(.layerMinXMaxYCorner)
        }
        
        if corners.isEmpty{
            corners = [.layerMinXMinYCorner,
                       .layerMaxXMinYCorner,
                       .layerMaxXMaxYCorner,
                       .layerMinXMaxYCorner]
        }
        applyCornerRadius(cornerRadius: cornerRadius, corners: corners)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if isCapsuleCircle{
            applyCornerRadius(cornerRadius: self.frame.height/2)
            
        }else if isCylinderCircle{
            applyCornerRadius(cornerRadius: self.frame.width/2)
            
        }else{
            self.applySpecificCornerRadius()
        }
    }
}

class CornerRadiusBorderButton: CornerRadiusButton{

    @IBInspectable private var borderWidth: CGFloat = 0.0
    @IBInspectable private var borderColor: UIColor = .clear
    @IBInspectable private var borderOpacity: CGFloat = 1.0

    override func awakeFromNib() {
        super.awakeFromNib()
        applyBorder(borderWidth: borderWidth, borderColor: borderColor, borderOpacity: borderOpacity)
    }

}

class CornerRadiusBorderShadowButton: CornerRadiusBorderButton{

    @IBInspectable private var shadowColor: UIColor = .clear
    @IBInspectable private var shadowOpacity: Float = 1.0
    @IBInspectable private var shadowXOffset: CGFloat = 0
    @IBInspectable private var shadowYOffset: CGFloat = 0
    @IBInspectable private var shadowBlur: CGFloat = 0
    @IBInspectable private var shadowSpread: CGFloat = 0

    override func layoutSubviews() {
        super.layoutSubviews()
        applyShadow(shadowColor: shadowColor, shadowOpacity: shadowOpacity, shadowXOffset: shadowXOffset, shadowYOffset: shadowYOffset, shadowBlur: shadowBlur, shadowSpread: shadowSpread)
    }

}


// For the custom Gradient
@IBDesignable
public class Gradient: UIView {
    @IBInspectable var startColor:   UIColor = .black { didSet { updateColors() }}
    @IBInspectable var endColor:     UIColor = .white { didSet { updateColors() }}
    @IBInspectable var startLocation: Double =   0 { didSet { updateLocations() }}
    @IBInspectable var endLocation:   Double =   1 { didSet { updateLocations() }}
    @IBInspectable var horizontalMode:  Bool =  false { didSet { updatePoints() }}
    @IBInspectable var diagonalMode:    Bool =  false { didSet { updatePoints() }}
    @IBInspectable var cornerRadius:CGFloat = 0.0 { didSet{ updatePoints() }}
    @IBInspectable var isCircle:Bool = false { didSet{ updatePoints() }}

    override public class var layerClass: AnyClass { CAGradientLayer.self }

    var gradientLayer: CAGradientLayer { layer as! CAGradientLayer }

    func updatePoints() {
        if horizontalMode {
            gradientLayer.startPoint = diagonalMode ? .init(x: 1, y: 0) : .init(x: 0, y: 0.5)
            gradientLayer.endPoint   = diagonalMode ? .init(x: 0, y: 1) : .init(x: 1, y: 0.5)
        } else {
            gradientLayer.startPoint = diagonalMode ? .init(x: 0, y: 0) : .init(x: 0.5, y: 0)
            gradientLayer.endPoint   = diagonalMode ? .init(x: 1, y: 1) : .init(x: 0.5, y: 1)
        }
    }
    func updateLocations() {
        gradientLayer.locations = [startLocation as NSNumber, endLocation as NSNumber]
    }
    func updateColors() {
        gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
    }
    func updateRadius() {
        layer.cornerRadius = isCircle ? (bounds.height / 2) : cornerRadius
    }
    override public func layoutSubviews() {
        super.layoutSubviews()
        updatePoints()
        updateLocations()
        updateColors()
        updateRadius()
    }
    override public func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        updatePoints()
        updateLocations()
        updateColors()
        updateRadius()
    }

}

// SCANNER CUTOUT VIEW

@IBDesignable
class BorderedCutoutView: UIView {

    @IBInspectable
    var bkgColor: UIColor = .systemBlue { didSet { setNeedsLayout() } }

    @IBInspectable
    var brdColor: UIColor = .white { didSet { setNeedsLayout() } }

    @IBInspectable
    var brdWidth: CGFloat = 1 { didSet { setNeedsLayout() } }

    @IBInspectable
    var legLength: CGFloat = 1 { didSet { setNeedsLayout() } }

    @IBInspectable
    var radius: CGFloat = 20 { didSet { setNeedsLayout() } }

    @IBInspectable
    var horizInset: CGFloat = 40.0 { didSet { setNeedsLayout() } }

    @IBInspectable
    var vertInset: CGFloat = 60.0 { didSet { setNeedsLayout() } }

    private let cutoutLayer = CAShapeLayer()
    private let borderLayer = CAShapeLayer()

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        backgroundColor = .clear
    }
    private func commonInit() -> Void {
        backgroundColor = .clear
        layer.addSublayer(cutoutLayer)
        layer.addSublayer(borderLayer)
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        let path = UIBezierPath(rect: bounds)
        let cp = UIBezierPath(roundedRect: bounds.insetBy(dx: horizInset, dy: vertInset), cornerRadius: radius)
        path.append(cp)
        path.usesEvenOddFillRule = true

        cutoutLayer.path = path.cgPath
        cutoutLayer.fillRule = .evenOdd
        cutoutLayer.fillColor = bkgColor.cgColor

        // corners path
        let insetRect = bounds.insetBy(dx: horizInset, dy: vertInset)
        let cornersPath = UIBezierPath()

        var pt1: CGPoint = .zero
        var pt2: CGPoint = .zero
        var curCenter: CGPoint = .zero

        // top-left
        pt1.x = insetRect.minX
        pt1.y = insetRect.minY + radius + legLength

        pt2 = pt1
        pt2.y -= legLength

        cornersPath.move(to: pt1)
        cornersPath.addLine(to: pt2)

        pt1 = cornersPath.currentPoint

        curCenter = pt1
        curCenter.x += radius

        cornersPath.addArc(withCenter: curCenter, radius: radius, startAngle: .pi * 1.0, endAngle: .pi * 1.5, clockwise: true)

        pt1 = cornersPath.currentPoint
        pt2 = pt1
        pt2.x += legLength

        cornersPath.addLine(to: pt2)

        // top-right
        pt1.x = insetRect.maxX - (radius + legLength)
        pt1.y = insetRect.minY

        pt2 = pt1
        pt2.x += legLength

        cornersPath.move(to: pt1)
        cornersPath.addLine(to: pt2)

        pt1 = cornersPath.currentPoint

        curCenter = pt1
        curCenter.y += radius

        cornersPath.addArc(withCenter: curCenter, radius: radius, startAngle: .pi * 1.5, endAngle: .pi * 2.0, clockwise: true)

        pt1 = cornersPath.currentPoint
        pt2 = pt1
        pt2.y += legLength

        cornersPath.addLine(to: pt2)

        // bottom-right
        pt1.x = insetRect.maxX
        pt1.y = insetRect.maxY - (radius + legLength)

        pt2 = pt1
        pt2.y += legLength

        cornersPath.move(to: pt1)
        cornersPath.addLine(to: pt2)

        pt1 = cornersPath.currentPoint

        curCenter = pt1
        curCenter.x -= radius

        cornersPath.addArc(withCenter: curCenter, radius: radius, startAngle: .pi * 0.0, endAngle: .pi * 0.5, clockwise: true)

        pt1 = cornersPath.currentPoint
        pt2 = pt1
        pt2.x -= legLength

        cornersPath.addLine(to: pt2)

        // bottom-left
        pt1.x = insetRect.minX + (radius + legLength)
        pt1.y = insetRect.maxY

        pt2 = pt1
        pt2.x -= legLength

        cornersPath.move(to: pt1)
        cornersPath.addLine(to: pt2)

        pt1 = cornersPath.currentPoint

        curCenter = pt1
        curCenter.y -= radius

        cornersPath.addArc(withCenter: curCenter, radius: radius, startAngle: .pi * 0.5, endAngle: .pi * 1.0, clockwise: true)

        pt1 = cornersPath.currentPoint
        pt2 = pt1
        pt2.y -= legLength

        cornersPath.addLine(to: pt2)

        borderLayer.path = cornersPath.cgPath
        borderLayer.fillColor = UIColor.clear.cgColor
        borderLayer.lineWidth = brdWidth
        borderLayer.strokeColor = brdColor.cgColor

    }

}

