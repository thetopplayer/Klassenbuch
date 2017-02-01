//
//  AppDelegate.swift
//  Klassenbuch
//
//  Created by Developing on 11.12.16.
//  Copyright © 2016 Hadorn Developing. All rights reserved.
//

import UIKit
import Firebase
import IQKeyboardManagerSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        

        FIRApp.configure()
        IQKeyboardManager.sharedManager().enable = true
        IQKeyboardManager.sharedManager().enableAutoToolbar = false

               // Override point for customization after application launch.
        return true
    }
 
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        
        
        //self.window?.rootViewController?.dismiss(animated: false, completion: nil)
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    
    
    
    /*
    func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
       
        // Setup the Quick 3D Touch Actions
        
        //Hausaufgaben Quick Action
        
        if shortcutItem.type == "Hausaufgaben" {
            
            if FIRAuth.auth()?.currentUser != nil {
                
                self.window = UIWindow(frame: UIScreen.main.bounds)
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let initialViewController1 = storyboard.instantiateViewController(withIdentifier: "AddHomeworkNC") as! UINavigationController
                self.window?.rootViewController = initialViewController1
                self.window?.makeKeyAndVisible()
            

            } else {
                
            self.window = UIWindow(frame: UIScreen.main.bounds)
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let initialViewController = storyboard.instantiateViewController(withIdentifier: "LoginNavigationVC") as! UINavigationController
            self.window?.rootViewController = initialViewController
            self.window?.makeKeyAndVisible()
            }}

        
        // Test Quick Action
        
        if shortcutItem.type == "Test" {
        
            if FIRAuth.auth()?.currentUser != nil{
        
                self.window = UIWindow(frame: UIScreen.main.bounds)
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let initialViewController = storyboard.instantiateViewController(withIdentifier: "AddTestNC") as! UINavigationController
                self.window?.rootViewController = initialViewController
                self.window?.makeKeyAndVisible()
        
            } else {

                self.window = UIWindow(frame: UIScreen.main.bounds)
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let initialViewController = storyboard.instantiateViewController(withIdentifier: "LoginNavigationVC") as! UINavigationController
                self.window?.rootViewController = initialViewController
                self.window?.makeKeyAndVisible()
            }}


        // Absenz Quick Action
        
        if shortcutItem.type == "Absenz" {
            
            if FIRAuth.auth()?.currentUser != nil{

                self.window = UIWindow(frame: UIScreen.main.bounds)
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let initialViewController = storyboard.instantiateViewController(withIdentifier: "AddAbsenzenNC") as! UINavigationController
                self.window?.rootViewController = initialViewController
                self.window?.makeKeyAndVisible()
           
            
            } else {
            
            
                self.window = UIWindow(frame: UIScreen.main.bounds)
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let initialViewController = storyboard.instantiateViewController(withIdentifier: "LoginNavigationVC") as! UINavigationController
                self.window?.rootViewController = initialViewController
                self.window?.makeKeyAndVisible()

            }
        }
    }



    func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
       
        if FIRAuth.auth()?.currentUser != nil{

        
        if shortcutItem.type == "Hausaufgaben" {
            let sb = UIStoryboard(name: "Main", bundle: nil)
            let addHAVC = sb.instantiateViewController(withIdentifier: "AddHomeworkNC") as! UINavigationController
            let root = UIApplication.shared.keyWindow?.rootViewController
            
            root?.present(addHAVC, animated: false, completion: { () -> Void in
                completionHandler(true)
            })
            
            
        }
        }else {}
    }



*/

    enum ShortcutIdentifier: String
    {
        case First
        
        case Second
        
        init?(fullType: String)
        {
        
            guard let last = fullType.components(separatedBy:".").last else {return nil}
        
            self.init(rawValue: last)
        }
        
        var type: String
            
            {
                return Bundle.main.bundleIdentifier! + ".\(self.rawValue)"
    
        }

    }
    
    
    func handleShortcutItem(shortcutItem: UIApplicationShortcutItem) -> Bool
    {
        
        
        var handled = false
        
        guard ShortcutIdentifier(fullType: shortcutItem.type) != nil else {return false}
        guard let shortcutType = shortcutItem.type as String? else {return false}
        
        switch (shortcutType)
        {
        
        case ShortcutIdentifier.First.type:
            handled = true
            
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let navVC = storyboard.instantiateViewController(withIdentifier: "AddHomeworkNC") as! UINavigationController
            self.window?.rootViewController?.present(navVC, animated: true, completion: nil)

  
            break
        case ShortcutIdentifier.Second.type:
            handled = true
            
            
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let navVC = storyboard.instantiateViewController(withIdentifier: "AddTestNC") as! UINavigationController
        self.window?.rootViewController?.present(navVC, animated: true, completion: nil)

    
            break
        default:
            break
        }

        
        return handled

        
    }
    
    
    
    func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
       
        let handledShortcutItem = self.handleShortcutItem(shortcutItem: shortcutItem)
        completionHandler(handledShortcutItem)
    }
    



}
            

        
        



