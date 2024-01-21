//
//  ViewController.swift
//  HelperClasses
//
//  Created by Apple on 14/12/23.
//

import UIKit

class ViewController: UIViewController {

    static func root(){
        AppDelegate.getAppDelegate()?.rootViewController(viewController: Self())
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}

