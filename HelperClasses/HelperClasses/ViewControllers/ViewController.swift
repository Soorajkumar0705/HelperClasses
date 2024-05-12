//
//  ViewController.swift
//  HelperClasses
//
//  Created by Apple on 14/12/23.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        captureUIBindingClosures()
        captureAPIBindingClosures()
        print("Succesfully Loaded VC.")
    }

    private func updateUI(){
        
        view.addTapGesture(configGesture: { [weak self] gesture in
            guard let _ = self else { return }
            
        }, action: { [weak self] gesture in
            guard let _ = self else { return }
            
        })
        
        view.addSwipeGesture(direction : .right, configGesture: { [weak self] gesture in
            guard let _ = self else { return }
            
        }, action: { [weak self] gesture in
            guard let _ = self else { return }
            
        })
        
        view.addLongTapGesture(configGesture: { [weak self] gesture in
            guard let _ = self else { return }
            
        }, action: { [weak self] gesture in
            guard let _ = self else { return }
            
            switch gesture.state{
                
            case .began:
                print("Began")
                
            case .changed:
                print("Changed")
                
            case .ended:
                print("Ended")
                
            case .cancelled:
                print("Canclled")
                
            case .possible:
                print("Possible")
                
            case .failed:
                print("Failed")
                
            @unknown default:
                fatalError()
            }
        })
    }
    
    private func captureUIBindingClosures(){
        
    }
    
    private func captureAPIBindingClosures(){
        
    }


}

