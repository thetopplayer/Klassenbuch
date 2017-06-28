//
//  NotificationTableViewController.swift
//  ICS4UTutorialTest
//
//  Created by Eric Qiu on 2016-06-11.
//  Copyright © 2016 Eric Qiu. All rights reserved.
//

import UIKit
import UserNotifications
import UserNotificationsUI

class NotificationTableViewController: UITableViewController {
    // Properties
    var reminders = [Reminder]()
    let dateFormatter = DateFormatter()
    let locale = Locale.current
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dateFormatter.locale = Locale.current
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        
        // load saved reminders, if any
        if let savedReminders = loadReminders() {
            reminders += savedReminders
        }
        
        tableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        tableView.reloadData()
    }
    
    // Table view data
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reminders.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "reminderCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        
        let reminder = reminders[indexPath.row]
        // Fetches the appropriate info if reminder exists
        cell.textLabel?.text = reminder.name
        cell.detailTextLabel?.text = "Due " + dateFormatter.string(from: reminder.time as Date)
        
        // Make due date red if overdue
        if (Date() as NSDate).earlierDate(reminder.time as Date) == reminder.time as Date {
            cell.detailTextLabel?.textColor = UIColor.red
        }
        else {
            cell.detailTextLabel?.textColor = UIColor.blue
        }
        return cell
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            let toRemove = reminders.remove(at: indexPath.row)
            
            //UIApplication.shared.cancelLocalNotification(toRemove.notification)
            
           // let center = UNUserNotificationCenter.current()
            //center.removeDeliveredNotifications(withIdentifiers: [toRemove])
            
            
            
            UNUserNotificationCenter.current().getPendingNotificationRequests { (notificationRequests) in
                var identifiers: [String] = []
                for notification:UNNotificationRequest in notificationRequests {
                    if notification.identifier == "identifierCancel" {
                        identifiers.append(notification.identifier)
                    }
                }
                UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: identifiers)
            }
            
            
            
            
            
            
            
            
            saveReminders()
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    // NSCoding
    
    func saveReminders() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(reminders, toFile: Reminder.ArchiveURL.path)
        if !isSuccessfulSave {
            print("Failed to save reminders...")
        }
    }
    
    func loadReminders() -> [Reminder]? {
        return NSKeyedUnarchiver.unarchiveObject(withFile: Reminder.ArchiveURL.path) as? [Reminder]
    }
    
    /* When returning from AddReminderViewController
    @IBAction func unwindToReminderList(_ sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? NewReminder, let reminder = sourceViewController.reminder {
            
            // add a new reminder
            let newIndexPath = IndexPath(row: reminders.count, section: 0)
            reminders.append(reminder)
            tableView.insertRows(at: [newIndexPath], with: .bottom)
            saveReminders()
            tableView.reloadData()
        }
        
        
    }*/}
