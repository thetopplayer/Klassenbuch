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
import FirebaseMessaging
import UserNotifications



extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
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

class weekday{
    class func getDayOfWeek(_ today:String) -> String? {
        
        let wochentag = String()
        let formatter  = DateFormatter()
        formatter.dateFormat = "dd MMM yyyy"
        guard let todayDate = formatter.date(from: today) else { return nil }
        let myCalendar = Calendar(identifier: .gregorian)
        let weekDay = myCalendar.component(.weekday, from: todayDate)
        
        if weekDay == 2 {
            return "Mo"
        } else  if weekDay == 3 {
            return "DI"
        }else  if weekDay == 4 {
            return "MI"
        }else  if weekDay == 5 {
            return "DO"
        }else  if weekDay == 6 {
            return "FR"
        }else  if weekDay == 7 {
            return "SA"
        }else  if weekDay == 1 {
            return "SO"
        }
        return wochentag
    }}

// [START ios_10_message_handling]
@available(iOS 10, *)
extension AppDelegate : UNUserNotificationCenterDelegate {
    
    // Receive displayed notifications for iOS 10 devices.
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        // Print full message.
        print(userInfo)
        
        // Change this to your preferred presentation option
        completionHandler([])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        // Print full message.
        print(userInfo)
        
        completionHandler()
    }
}
// [END ios_10_message_handling]
// [START ios_10_data_message_handling]
extension AppDelegate : FIRMessagingDelegate {
    // Receive data message on iOS 10 devices while app is in the foreground.
    func applicationReceivedRemoteMessage(_ remoteMessage: FIRMessagingRemoteMessage) {
        print(remoteMessage.appData)
    }
}
// [END ios_10_data_message_handling]



//Old Extensions
/*extension AppDelegate : UNUserNotificationCenterDelegate {
 
 // Receive displayed notifications for iOS 10 devices.
 
 func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
 let userInfo = notification.request.content.userInfo
 // Print message ID.
 print("Message ID: \(userInfo["gcm.message_id"]!)")
 
 // Print full message.
 print("%@", userInfo)
 
 }
 
 }
 
 extension AppDelegate : FIRMessagingDelegate {
 // Receive data message on iOS 10 devices.
 func applicationReceivedRemoteMessage(_ remoteMessage: FIRMessagingRemoteMessage) {
 print("%@", remoteMessage.appData)
 }
 }   */

