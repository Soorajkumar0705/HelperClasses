//
//  Extension+UIView.swift
//  HelperClasses
//
//  Created by Apple on 14/12/23.
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


extension UIView{
    
    @discardableResult
    func fromNib<T : UIView>() -> T? {
        guard let contentView = Bundle(for: type(of: self)).loadNibNamed(type(of: self).className, owner: self, options: nil)?.first as? T else {
            return nil
        }
        addSubview(contentView)
        contentView.fillSuperview(bounds: bounds)
        return contentView
    }

    func fillSuperview(bounds: CGRect) {
        self.frame = bounds
        self.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
    
    func showPopUpViewin(in view: UIView, with animationTime: TimeInterval = 0.25){
        self.alpha = 0
        self.frame = view.bounds

        UIView.animate(withDuration: animationTime, animations: { [ weak self ] in
            guard let self else { return }
            view.addSubview(self)
            self.frame = view.bounds
            view.bringSubviewToFront(self)
            self.alpha = 1
            self.layoutSubviews()
        })
    }
    
    func setRandomUniqueAccessibilityIdentifier() {
        self.accessibilityIdentifier = UUID().uuidString
    }
}

extension UIView {
    func findViewController() -> UIViewController? {
        if let nextResponder = self.next as? UIViewController {
            return nextResponder
        } else if let nextResponder = self.next as? UIView {
            return nextResponder.findViewController()
        } else {
            return nil
        }
    }
}

extension UIView{
    
    func applyCornerRadius(cornerRadius: CGFloat, corners: CACornerMask = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMaxXMaxYCorner, .layerMinXMaxYCorner]){
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

// Tap Gesture
extension UIView{

    func addTapGesture(configGesture: (UITapGestureRecognizer) -> Void = { _ in }, action: @escaping (UITapGestureRecognizer) -> Void = { _ in }){
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture(_ : )))
        configGesture(tapGesture)
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(tapGesture)

        // Store the action closure as an associated object
        objc_setAssociatedObject(self, &AssociatedTapGestureActionKeys.singleTapAction, action, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)

    }

    @objc private func handleTapGesture(_ gesture: UITapGestureRecognizer){
        if let action = objc_getAssociatedObject(self, &AssociatedTapGestureActionKeys.singleTapAction) as? (UITapGestureRecognizer) -> Void {
            action(gesture)
        }
        print("Tap")
    }

    private struct AssociatedTapGestureActionKeys{
        static var singleTapAction = "singleTapAction"
    }

}

// Long Tap Gesture
extension UIView {
    
    func addLongTapGesture(configGesture: (UILongPressGestureRecognizer) -> Void = { _ in }, action: @escaping (UILongPressGestureRecognizer) -> Void = { _ in }) {
        let longTapGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongTapGesture(_:)))
        configGesture(longTapGesture)
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(longTapGesture)
        
        // Store the action closure as an associated object
        objc_setAssociatedObject(self, &AssociatedLongTapGestureActionKeys.longTapAction, action, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    
    @objc private func handleLongTapGesture(_ gesture: UILongPressGestureRecognizer) {
        if let action = objc_getAssociatedObject(self, &AssociatedLongTapGestureActionKeys.longTapAction) as? (UILongPressGestureRecognizer) -> Void {
            action(gesture)
        }
        print("Long Tap")
    }
    
    private struct AssociatedLongTapGestureActionKeys {
        static var longTapAction = "longTapAction"
    }
}

// Swipe Gesture
extension UIView {

    func addSwipeGesture(direction: UISwipeGestureRecognizer.Direction, configGesture: (UISwipeGestureRecognizer) -> Void = { _ in }, action: @escaping (UISwipeGestureRecognizer) -> Void = { _ in }) {

        let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeGesture(_:)))
        swipeGesture.direction = direction
        configGesture(swipeGesture)
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(swipeGesture)

        // Store the action closure as an associated object based upon the swipe direction
        switch direction{

        case .up:
            objc_setAssociatedObject(self, &AssociatedSwipeGestureActionKeys.swipeUpAction, action, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            print("up")

        case .down:
            objc_setAssociatedObject(self, &AssociatedSwipeGestureActionKeys.swipeDownAction, action, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            print("down")

        case.left:
            objc_setAssociatedObject(self, &AssociatedSwipeGestureActionKeys.swipeLeftAction, action, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            print("left")

        case .right:
            objc_setAssociatedObject(self, &AssociatedSwipeGestureActionKeys.swipeRightAction, action, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            print("Right")

        default:
            objc_setAssociatedObject(self, &AssociatedSwipeGestureActionKeys.swipeUnknownAction, action, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            print("unknown direction")
        }
    }

    @objc private func handleSwipeGesture(_ gesture: UISwipeGestureRecognizer) {

        switch gesture.direction{

        case .up:
            if let action = objc_getAssociatedObject(self, &AssociatedSwipeGestureActionKeys.swipeUpAction) as? (UISwipeGestureRecognizer) -> Void {
                action(gesture)
            }
            print("up")

        case .down:
            if let action = objc_getAssociatedObject(self, &AssociatedSwipeGestureActionKeys.swipeDownAction) as? (UISwipeGestureRecognizer) -> Void {
                action(gesture)
            }
            print("down")

        case.left:
            if let action = objc_getAssociatedObject(self, &AssociatedSwipeGestureActionKeys.swipeLeftAction) as? (UISwipeGestureRecognizer) -> Void {
                action(gesture)
            }
            print("left")

        case .right:
            if let action = objc_getAssociatedObject(self, &AssociatedSwipeGestureActionKeys.swipeRightAction) as? (UISwipeGestureRecognizer) -> Void {
                action(gesture)
            }
            print("Right")

        default:
            if let action = objc_getAssociatedObject(self, &AssociatedSwipeGestureActionKeys.swipeUnknownAction) as? (UISwipeGestureRecognizer) -> Void {
                action(gesture)
            }
            print("unknown direction")
        }
    }

    private struct AssociatedSwipeGestureActionKeys {
        static var swipeUpAction = "swipeUpAction"
        static var swipeDownAction = "swipeDownAction"
        static var swipeRightAction = "swipeRightAction"
        static var swipeLeftAction = "swipeLeftAction"
        static var swipeUnknownAction = "swipeUnknownAction"
    }
}


// BELOW FUNCTION HELPS TO CONVERT THE UICOLOR TO CGCOLOR IF THE BORDERCOLOR IS ADDED FROM THE RUNTIME ATTRIBUTE IN STORYBOARD
extension CALayer {
    open override func setValue(_ value: Any?, forKey key: String) {
        guard key == "borderColor", let color = value as? UIColor else {
            super.setValue(value, forKey: key)
            return
        }

        self.borderColor = color.cgColor
    }
}

extension UITapGestureRecognizer {

    func didTapAttributedTextInLabel(label: UILabel, inRange targetRange: NSRange) -> Bool {
        // Create instances of NSLayoutManager, NSTextContainer and NSTextStorage
        let layoutManager = NSLayoutManager()
        let textContainer = NSTextContainer(size: CGSize.zero)
        let textStorage = NSTextStorage(attributedString: label.attributedText!)

        // Configure layoutManager and textStorage
        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)

        // Configure textContainer
        textContainer.lineFragmentPadding = 0.0
        textContainer.lineBreakMode = label.lineBreakMode
        textContainer.maximumNumberOfLines = label.numberOfLines
        let labelSize = label.bounds.size
        textContainer.size = labelSize

        // Find the tapped character location and compare it to the specified range
        let locationOfTouchInLabel = self.location(in: label)
        let textBoundingBox = layoutManager.usedRect(for: textContainer)
        //let textContainerOffset = CGPointMake((labelSize.width - textBoundingBox.size.width) * 0.5 - textBoundingBox.origin.x,
        //(labelSize.height - textBoundingBox.size.height) * 0.5 - textBoundingBox.origin.y);
        let textContainerOffset = CGPoint(x: (labelSize.width - textBoundingBox.size.width) * 0.5 - textBoundingBox.origin.x, y: (labelSize.height - textBoundingBox.size.height) * 0.5 - textBoundingBox.origin.y)

        //let locationOfTouchInTextContainer = CGPointMake(locationOfTouchInLabel.x - textContainerOffset.x,
        // locationOfTouchInLabel.y - textContainerOffset.y);
        let locationOfTouchInTextContainer = CGPoint(x: locationOfTouchInLabel.x - textContainerOffset.x, y: locationOfTouchInLabel.y - textContainerOffset.y)
        let indexOfCharacter = layoutManager.characterIndex(for: locationOfTouchInTextContainer, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        return NSLocationInRange(indexOfCharacter, targetRange)
    }
}
