//
//  Extension+UIViewController.swift
//  HelperClasses
//
//  Created by Apple on 28/01/24.
//

import UIKit


extension UIViewController{
    
    func pushVC<viewController: UIViewController>(storyboard: UIStoryboard, viewController: viewController.Type, passData: ((viewController) -> Void)? = nil, animated: Bool = true){
     
        if let vc = storyboard.instantiateViewController(withIdentifier: viewController.className) as? viewController{
            passData?(vc)
            self.navigationController?.pushViewController(vc, animated: animated)
        }else{
            print("Not found the view controller in storyboard while instantiating.")
        }
        
    }
    
    func popVC(animated: Bool = true){
        self.navigationController?.popViewController(animated: animated)
    }
    
   static func rootVC(storyboard: UIStoryboard, passData: ((UIViewController) -> Void)? = nil, animated: Bool = true){
        if let vc = storyboard.instantiateViewController(withIdentifier: Self.className) as? Self{
            passData?(vc)
            AppDelegate.getAppDelegate()?.rootViewController(viewController: vc)
        }else{
            print("Not found the view controller in storyboard while instantiating.")
        }
    }
    
}
