//
//  AppDelegate.swift
//  HelperClasses
//
//  Created by Apple on 14/12/23.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        setUpNetworkReachability()
        
        // make the view controller as the root view controller here.
        ViewController.rootVC(storyboard: .main)
        return true
    }
    
    static func getAppDelegate() -> Self?{
        return UIApplication.shared.delegate as? Self
    }
    
    func getActiveVC() -> UIViewController?{
        guard let vc = (self.window?.rootViewController as? UINavigationController)?.viewControllers.last else{
            print("Not found the root view controller as? UIViewController in ",#function)
            return nil
        }
        return vc
    }   // getActiveVC
    
    
    private func setUpNetworkReachability(){

        do {
            try Network.reachability = Reachability(hostname: "www.google.com")
        }
        catch {
            switch error as? Network.Error {
            case let .failedToCreateWith(hostname)?:
                print("Network error:\nFailed to create reachability object With host named:", hostname)
            case let .failedToInitializeWith(address)?:
                print("Network error:\nFailed to initialize reachability object With address:", address)
            case .failedToSetCallout?:
                print("Network error:\nFailed to set callout")
            case .failedToSetDispatchQueue?:
                print("Network error:\nFailed to set DispatchQueue")
            case .none:
                print(error)
            }
        }
        NotificationCenter.default.addObserver(self, selector: #selector(statusManager), name: .flagsChanged,
                                               object: nil)
    }

    @objc private func statusManager(_ notification: Notification) {
        updateUserInterface()
    }

    private func updateUserInterface() {
        guard let status = Network.reachability?.status else { return }
        switch status {
        case .unreachable:
            break
        case .wwan:
            break
        case .wifi:
            break
        }
        print("Reachability Summary")
        print("Status:", Network.reachability.status)
        print("HostName:", Network.reachability.hostname ?? "nil")
        print("Reachable:", Network.reachability.isReachable)
        print("Wifi:", Network.reachability.isReachableViaWiFi)
    }
    
    func rootViewController(viewController : UIViewController){
        
        if self.window == nil{
            self.window = UIWindow(frame: UIScreen.main.bounds)
        }
        let navController = UINavigationController()
        navController.viewControllers = [viewController]
        navController.isNavigationBarHidden = true
        navController.interactivePopGestureRecognizer?.isEnabled = false
        window?.makeKeyAndVisible()
        window?.rootViewController = navController
    }


}

