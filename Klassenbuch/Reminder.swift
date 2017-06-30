//
//  Reminder.swift
//  Klassenbuch
//
//  Created by Developing on 24.06.17.
//  Copyright © 2017 Hadorn Developing. All rights reserved.
//

import Foundation
import UIKit
import UserNotifications
import UserNotificationsUI

class Reminder: NSObject, NSCoding {
    
    // Properties
    var notification: UNNotification
    var name: String
    var time: Date 
    
    // Archive Paths for Persistent Data
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("reminders")
    
    // enum for property types
    struct PropertyKey {
        static let nameKey = "name"
        static let timeKey = "time"
        static let notificationKey = "notification"
    }
    
    // Initializer
    init(name: String, time: Date, notification: UNNotification) {
        // set properties
        self.name = name
        self.time = time
        self.notification = notification
        
        super.init()
    }
    
    // Destructor
    deinit {
        // cancel notification

        UNUserNotificationCenter.current().getPendingNotificationRequests { (notificationRequests) in
            var identifiers: [String] = []
            for notification:UNNotificationRequest in notificationRequests {
                if notification.identifier == "identifierCancel" {
                    identifiers.append(notification.identifier)
                }
            }
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: identifiers)
        }
        //UIApplication.shared.cancelLocalNotification(self.notification)
        // UNUserNotificationCenter.removePendingNotificationRequests(self.notification)
        //   func removePendingNotificationRequests(withIdentifiers identifiers: [notification]){}
    }
    
    
    
    // NSCoding
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: PropertyKey.nameKey)
        aCoder.encode(time, forKey: PropertyKey.timeKey)
        aCoder.encode(notification, forKey: PropertyKey.notificationKey)
    }
    
    required convenience init(coder aDecoder: NSCoder) {
        let name = aDecoder.decodeObject(forKey: PropertyKey.nameKey) as! String
        
        // Because photo is an optional property of Meal, use conditional cast.
        let time = aDecoder.decodeObject(forKey: PropertyKey.timeKey) as! Date
        
        let notification = aDecoder.decodeObject(forKey: PropertyKey.notificationKey) as! UNNotification
        
        // Must call designated initializer.
        self.init(name: name, time: time, notification: notification)
    }
}
