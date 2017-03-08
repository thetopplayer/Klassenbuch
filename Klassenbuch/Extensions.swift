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


extension Int {
    
    var convertTimestampToDate: String {
        
        get {
            
            let date = Date(timeIntervalSince1970: Double(self)/1000.0)
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd MMM yyyy"
            
            return dateFormatter.string(from: date)
            
        }
    }
    
}


extension Date {
    
    /// This computed property will take date and convert the date to zero hours e.g. 7 Mar 2017 12:08PM After 7 Mar 2017 00:00PM
    
    var getDateFromZeroHour: Int {
        
        get {
            
            let oldDate: Date = self
            let calendar: Calendar = Calendar.current
            var comps: DateComponents = (calendar as NSCalendar).components([NSCalendar.Unit.year , NSCalendar.Unit.month , NSCalendar.Unit.day], from: oldDate)
            comps.hour = 0
            comps.minute = 0
            comps.second = 0
            (comps as NSDateComponents).timeZone = calendar.timeZone
            let newDate: Date = calendar.date(from: comps)!
            return Int(newDate.timeIntervalSince1970*1000)
        }
    }
    
}


