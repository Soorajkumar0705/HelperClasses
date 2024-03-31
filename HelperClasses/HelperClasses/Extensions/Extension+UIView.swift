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

        guard let key = AssociatedTapGestureActionKeys.singleTapAction else {
            fatalError("AssociatedTapGestureActionKeys.singleTapAction is nil.")
        }
        objc_setAssociatedObject(self, key, action, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)

    }

    @objc private func handleTapGesture(_ gesture: UITapGestureRecognizer){
        guard let key = AssociatedTapGestureActionKeys.singleTapAction else {
            fatalError("AssociatedTapGestureActionKeys.singleTapAction is nil.")
        }
        if let action = objc_getAssociatedObject(self, key) as? (UITapGestureRecognizer) -> Void {
            action(gesture)
        }
        print("Tap")
    }

    private struct AssociatedTapGestureActionKeys{
        static let singleTapAction = UnsafeRawPointer(bitPattern: "singleTapAction".hashValue)
    }

}

// Long Tap Gesture
extension UIView {
    
    func addLongTapGesture(configGesture: ((UILongPressGestureRecognizer) -> Void)? = nil, action: ((UILongPressGestureRecognizer) -> Void)? = nil ) {
        
        let longTapGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongTapGesture(_:)))
        configGesture?(longTapGesture)
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(longTapGesture)
        
        // Store the action closure as an associated object
        guard let key = AssociatedLongTapGestureActionKeys.longTapAction else {
            fatalError("AssociatedLongTapGestureActionKeys.longTapAction is nil.")
        }
        objc_setAssociatedObject(self, key, action, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    
    @objc private func handleLongTapGesture(_ gesture: UILongPressGestureRecognizer) {
        guard let key = AssociatedLongTapGestureActionKeys.longTapAction else {
            fatalError("AssociatedLongTapGestureActionKeys.longTapAction is nil.")
        }
        if let action = objc_getAssociatedObject(self, key) as? (UILongPressGestureRecognizer) -> Void {
            action(gesture)
        }
        print("Long Tap")
    }
    
    private struct AssociatedLongTapGestureActionKeys {
        static let longTapAction = UnsafeRawPointer(bitPattern: "longTapAction".hashValue)
    }
}

// Swipe Gesture
extension UIView {

    func addSwipeGesture(direction: UISwipeGestureRecognizer.Direction, configGesture: ((UISwipeGestureRecognizer) -> Void)? = nil, action: ((UISwipeGestureRecognizer) -> Void)? = nil) {

        let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeGesture(_:)))
        swipeGesture.direction = direction
        configGesture?(swipeGesture)
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(swipeGesture)

        // Store the action closure as an associated object based upon the swipe direction
        switch direction{

        case .up:
            guard let key = AssociatedSwipeGestureActionKeys.swipeUpAction else {
                fatalError("AssociatedSwipeGestureActionKeys.swipeUpAction is nil.")
            }
            objc_setAssociatedObject(self, key, action, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            print("up")

        case .down:
            guard let key = AssociatedSwipeGestureActionKeys.swipeDownAction else {
                fatalError("AssociatedSwipeGestureActionKeys.swipeDownAction is nil.")
            }
            objc_setAssociatedObject(self, key, action, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            print("down")

        case.left:
            guard let key = AssociatedSwipeGestureActionKeys.swipeLeftAction else {
                fatalError("AssociatedSwipeGestureActionKeys.swipeLeftAction is nil.")
            }
            objc_setAssociatedObject(self, key, action, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            print("left")

        case .right:
            guard let key = AssociatedSwipeGestureActionKeys.swipeRightAction else {
                fatalError("AssociatedSwipeGestureActionKeys.swipeRightAction is nil.")
            }
            objc_setAssociatedObject(self, key, action, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            print("Right")

        default:
            guard let key = AssociatedSwipeGestureActionKeys.swipeUnknownAction else {
                fatalError("AssociatedSwipeGestureActionKeys.swipeUnknownAction is nil.")
            }
            objc_setAssociatedObject(self, key, action, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            
            print("unknown direction")
        }
    }

    @objc private func handleSwipeGesture(_ gesture: UISwipeGestureRecognizer) {
        var mainKey : UnsafeRawPointer!
        
        switch gesture.direction{

        case .up:
            guard let key = AssociatedSwipeGestureActionKeys.swipeUpAction else {
                fatalError("AssociatedSwipeGestureActionKeys.swipeUpAction is nil.")
            }
            mainKey = key
            print("up")

        case .down:
            
            guard let key = AssociatedSwipeGestureActionKeys.swipeDownAction else {
                fatalError("AssociatedSwipeGestureActionKeys.swipeDownAction is nil.")
            }
            mainKey = key
            print("down")

        case.left:
            
            guard let key = AssociatedSwipeGestureActionKeys.swipeLeftAction else {
                fatalError("AssociatedSwipeGestureActionKeys.swipeLeftAction is nil.")
            }
            mainKey = key
            print("left")

        case .right:
            guard let key = AssociatedSwipeGestureActionKeys.swipeRightAction else {
                fatalError("AssociatedSwipeGestureActionKeys.swipeRightAction is nil.")
            }
            mainKey = key
            print("Right")

        default:
            
            guard let key = AssociatedSwipeGestureActionKeys.swipeUnknownAction else {
                fatalError("AssociatedSwipeGestureActionKeys.swipeUnknownAction is nil.")
            }
            mainKey = key
            print("unknown direction")
        }
        
        
        if let action = objc_getAssociatedObject(self, mainKey) as? (UISwipeGestureRecognizer) -> Void {
            action(gesture)
        }
        
    }
    
    private struct AssociatedSwipeGestureActionKeys {
        static let swipeUpAction = UnsafeRawPointer(bitPattern: "swipeUpAction".hashValue)
        static let swipeDownAction = UnsafeRawPointer(bitPattern: "swipeDownAction".hashValue)
        static let swipeRightAction = UnsafeRawPointer(bitPattern: "swipeRightAction".hashValue)
        static let swipeLeftAction = UnsafeRawPointer(bitPattern: "swipeLeftAction".hashValue)
        static let swipeUnknownAction = UnsafeRawPointer(bitPattern: "swipeUnknownAction".hashValue)
    }
    
}

extension UIScrollView {
    
    func addPullToRefresh(configControll: ((UIRefreshControl) -> Void)? = nil, action: ((UIRefreshControl) -> Void)? = nil){
        
        let refreshControll = UIRefreshControl()
        refreshControll.addTarget(self, action: #selector(handlePullToRefresh(_:)), for: .valueChanged)
        configControll?(refreshControll)
        self.refreshControl = refreshControll
        
        guard let key = AssociatedPullToRefreshActionKeys.pullAction else {
            fatalError("AssociatedPullToRefreshActionKeys.pullAction is nil.")
        }
        objc_setAssociatedObject(self, key, action, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    
    @objc private func handlePullToRefresh(_ refreshControll: UIRefreshControl){
        guard let key = AssociatedPullToRefreshActionKeys.pullAction else {
            fatalError("AssociatedPullToRefreshActionKeys.pullAction is nil.")
        }
        guard let action = objc_getAssociatedObject(self, key) as? (UIRefreshControl) -> Void else {
            fatalError("AssociatedPullToRefreshActionKeys.pullAction is nil.")
        }
        action(refreshControll)
        print("Pull To Refresh")
    }
    
    private struct AssociatedPullToRefreshActionKeys {
        static let pullAction = UnsafeRawPointer(bitPattern: "pullAction".hashValue)
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
