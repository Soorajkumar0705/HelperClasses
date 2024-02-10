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
//        ViewController.rootVC(storyboard: .main)
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    
    static func getAppDelegate() -> AppDelegate?{
        return UIApplication.shared.delegate as? AppDelegate
    }
    
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

