//
//  AppDelegate.swift
//  Example
//
//  Created by SAIF ULLAH on 08/03/2021.
//

import UIKit
import SFSideMenu

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

var window: UIWindow?
    var _drawerViewController : SFSideMenuViewController!
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        startApp()
        
        return true
    }
    func startApp() {
        let frame = UIScreen.main.bounds
        window = UIWindow(frame: frame )
        _drawerViewController = SFSideMenuViewController()
        let vc = ViewController.instance()
      //  let navigationController = UINavigationController(rootViewController: )
        _drawerViewController?.centerViewController = vc
        _drawerViewController?.leftViewController = LeftMenuview(frame: frame)
       // _drawerViewController?.rightViewController = ViewController()
        
        window?.rootViewController = _drawerViewController
        window?.makeKeyAndVisible()
        
        
        //let menu =
        //navigationController.viewControllers.append(menu)
        //let vc = HomeServicesListingViewController.instantiate(from: StoryBoardName.home)
       // navigationController.viewControllers.append(vc)
        
    }



}

