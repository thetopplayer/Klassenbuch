//
//  Extensions.swift
//  Klassenbuch
//
//  Created by Developing on 08.01.17.
//  Copyright © 2017 Hadorn Developing. All rights reserved.
//

import Foundation
import UIKit
import Firebase



extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func checkUserStatus() {
    
        FIRAuth.auth()?.addStateDidChangeListener { auth, authuser in
            if authuser != nil {
                // User is signed in. Show home screen
                self.performSegue(withIdentifier: "AppHomepageSegue", sender: self)
            } else {
                // No User is signed in. Show user the login screen
            }
        }

    
    
    }
}

// Now in every UIViewController, all you have to do is call this function:

/*override func viewDidLoad() {
    super.viewDidLoad()
 
    self.hideKeyboardWhenTappedAround()
 
}
 */



