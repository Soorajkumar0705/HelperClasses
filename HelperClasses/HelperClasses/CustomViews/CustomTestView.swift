//
//  CustomTestView.swift
//  HelperClasses
//
//  Created by Meet Appmatictech on 25/03/24.
//

import UIKit

class CustomTestView: UIView {

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialCommit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialCommit()
    }
    
    deinit{
        print("Removed \(className) automatically from memory.")
    }
    
    private func initialCommit(){
        fromNib()
        updateUI()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        updateUI()
    }
    
    private func updateUI(){
        self.accessibilityIdentifier = className
        self.backgroundColor = .clear
        
    }

}
