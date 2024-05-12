//
//  Extension+UIViewController.swift
//  HelperClasses
//
//  Created by Apple on 28/01/24.
//

import UIKit


extension UIViewController{
    
    static func rootVC<viewController : UIViewController>(storyboard : UIStoryboard, viewController : viewController.Type = UIViewController.self, passData: ( (viewController) -> Void )? = nil) {
        if let vc = storyboard.instantiateViewController(withIdentifier: Self.className) as? viewController{
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
    
    func showAlertPopUp(title : String, message : String,
                        isShowBtnCancel: Bool = true, isShowBtnOk: Bool = true,
                        btnCancelTitle: String = "Cancel", btnOkTitle: String = "Ok",
                        onClickBtnCancel : VoidClosure? = nil, onClickBtnOk: VoidClosure? = nil, animated : Bool = true){
        
        let alertView = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        if isShowBtnCancel{
            let alertAction = UIAlertAction(title: btnCancelTitle, style: .default, handler: { [weak self] _  in
                guard let _ = self else { return }
                onClickBtnCancel?()
            })
            
            alertView.addAction(alertAction)
        }
        
        if isShowBtnOk{
            let alertAction = UIAlertAction(title: btnOkTitle, style: .default, handler: { [weak self] _  in
                guard let _ = self else { return }
                onClickBtnOk?()
            })
            
            alertView.addAction(alertAction)
        }
        
        present(alertView, animated: animated)
    }
    
}

extension UIViewController {
    
    func checkInternetConnection(connected : VoidClosure? = nil, notConnected : VoidClosure? = nil){
        
        if ComonFunctions.isNetworkAvailable() {
            connected?()
        }else{
            notConnected?()
        }
        
    }
    
}
