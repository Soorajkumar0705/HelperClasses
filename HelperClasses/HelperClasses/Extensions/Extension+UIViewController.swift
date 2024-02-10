//
//  Extension+UIViewController.swift
//  HelperClasses
//
//  Created by Apple on 28/01/24.
//

import UIKit


extension UIViewController{
    
    static func rootVC(storyboard : UIStoryboard , passData: ( (UIViewController) -> Void )? = nil) {
        if let vc = storyboard.instantiateViewController(withIdentifier: Self.className) as? Self{
            passData?(vc)
            AppDelegate.getAppDelegate()?.rootViewController(viewController: vc)
        }else{
            print("ViewController not found in storyboard while insantiating.")
        }
    }

    func pushVC<viewController : UIViewController>(storyboard : UIStoryboard, viewController : viewController.Type, passData: ((viewController) -> Void)? = nil , animated: Bool = true){

        if let vc = storyboard.instantiateViewController(withIdentifier: viewController.className) as? viewController{
            passData?(vc)
            self.navigationController?.pushViewController(vc, animated: animated)
        }else{
            print("ViewController not found in storyboard while insantiating.")
        }
    }

    func popVC(animated: Bool = true){
        self.navigationController?.popViewController(animated: animated)
    }

    func popMultipleViewController(count : Int = 1, animated:Bool = true) {
        let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController]
        self.navigationController!.popToViewController(viewControllers[viewControllers.count - count-1], animated: animated)
    }

    func popLastViewController(){
        let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController]
        if let index = viewControllers.firstIndex(where: { $0 == self }) {
            self.navigationController?.viewControllers.remove(at: index - 1)
        }
    }

    func hideNavigationBar(){
        self.navigationController?.isNavigationBarHidden = true
    }

    func showNavigationBar(){
        self.navigationController?.isNavigationBarHidden = false
    }

}
