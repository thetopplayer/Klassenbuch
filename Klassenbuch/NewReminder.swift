//
//  NewReminder.swift
//  Klassenbuch
//
//  Created by Developing on 23.06.17.
//  Copyright © 2017 Hadorn Developing. All rights reserved.
//

import UIKit
import UserNotifications
import UserNotificationsUI

class NewReminder: UITableViewController, UNUserNotificationCenterDelegate {

    // Outlets
    @IBOutlet weak var PersonLabel: UILabel!
    @IBOutlet weak var DatumLabel: UILabel!
    @IBOutlet weak var AbgabeDatumLabel: UILabel!
    @IBOutlet weak var DauerderAbsenzLabel: UILabel!
    
    @IBOutlet weak var DateSegmentedControl: UISegmentedControl!
    @IBOutlet weak var TimeSegmentedControl: UISegmentedControl!
    
    
    
    // Variables
    
    var reminder: Reminder?
    
    var Person: String?
    var Datum: String?
    var AbgabeDatum: String?
    var DauerderAbsenz: String?
    
    var rowArray = [["1","1","1","1"],["1"],["1"],["1"]]
    
    //var FireTime: Date
    var TodayTomorrow = "bis Morgen unterschrieben abgeben."

    var triggerDate: Date?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.navigationController?.isNavigationBarHidden = false
    }
    

    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    override func viewDidLoad() {
        super.viewDidLoad()
      
    // Labels with PreInformation
    PersonLabel.text! = Person!
    DatumLabel.text! = Datum!
    DauerderAbsenzLabel.text! = DauerderAbsenz!
    
    print(Datum!)
 
    
        //Date formatter
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "dd MMMM yyyy"
        let DateinDate = dateformatter.date(from: Datum!)
        
        let daysToAdd = 14
        var dateComponent = DateComponents()
        dateComponent.day = daysToAdd
        
        let FutureDateinDate = Calendar.current.date(byAdding: dateComponent, to: DateinDate!)
        let futureDateinString = dateformatter.string(from: FutureDateinDate!)
        print(futureDateinString)

        AbgabeDatumLabel.text! = futureDateinString
        print(FutureDateinDate!)
        
    }

    

    
    
    
    
    
    
    
    
    
    @IBAction func DateToggle(_ sender: UISegmentedControl) {
        
    }
  
    
    @IBAction func TimeToggle(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            print("Morgen")
            
        }else if  sender.selectedSegmentIndex == 1 {
            print("Mittag")
            
        }else if sender.selectedSegmentIndex == 2 {
            print ("Abend")
            
        }
    }
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.rowArray[section].count
    }


    @IBAction func SavingReminding(_ sender: Any) {

        var triggerDate: Date = Date()
        
        // triggerdate will be the date for trigger
        
        
        
       // Date formatter for Morning
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "dd MMMM yyyy"
        let DateinDate = dateformatter.date(from: Datum!)
        
        let daysToAdd = 12
        let hoursToAdd = 2
        var dateComponent = DateComponents()
        dateComponent.day = daysToAdd
        dateComponent.hour = hoursToAdd
        
        let PrePreDateinDate = Calendar.current.date(byAdding: dateComponent, to: DateinDate!)
        let PrePreDateinString = dateformatter.string(from: PrePreDateinDate!)
        print(PrePreDateinString)
        print(PrePreDateinDate!)
        
        
        // Date formatter for Midday
        
        //Date formatter
        let dateformatter2 = DateFormatter()
        dateformatter2.dateFormat = "dd MMMM yyyy"
        let DateinDate2 = dateformatter2.date(from: Datum!)
        
        let daysToAdd2 = 13
        let hoursToAdd2 = 2
        var dateComponent2 = DateComponents()
        dateComponent2.day = daysToAdd2
        dateComponent2.hour = hoursToAdd2
        
        
        let PreDateinDate = Calendar.current.date(byAdding: dateComponent2, to: DateinDate2!)
        let PreDateinString = dateformatter2.string(from: PreDateinDate!)
        print(PreDateinString)
        print(PreDateinDate!)
        
        
        // Date formatter for Evening
        
        //Date formatter
        let dateformatter3 = DateFormatter()
        dateformatter3.dateFormat = "dd MMMM yyyy"
        let DateinDate3 = dateformatter3.date(from: Datum!)
        
        let daysToAdd3 = 14
        let hoursToAdd3 = 2
        var dateComponent3 = DateComponents()
        dateComponent3.day = daysToAdd3
        dateComponent3.hour = hoursToAdd3
        
        let NowDateinDate = Calendar.current.date(byAdding: dateComponent3, to: DateinDate3!)
        let NowDateinString = dateformatter3.string(from: NowDateinDate!)
        print(NowDateinDate!)
        print(NowDateinString)
        
        
        
        if DateSegmentedControl.selectedSegmentIndex == 0 && TimeSegmentedControl.selectedSegmentIndex == 0 {
            
        triggerDate = PrePreDateinDate! + 36000
        TodayTomorrow = "bis Übermorgen unterschrieben abgeben."
        print("\(triggerDate) this is the TriggerDate")
            
        } else if DateSegmentedControl.selectedSegmentIndex == 0 && TimeSegmentedControl.selectedSegmentIndex == 1 {
            
        triggerDate = PrePreDateinDate! + 36000 + 14400
        TodayTomorrow = "bis Übermorgen unterschrieben abgeben."
        print("\(triggerDate) this is the TriggerDate")
            
        } else if DateSegmentedControl.selectedSegmentIndex == 0 && TimeSegmentedControl.selectedSegmentIndex == 2 {
            
        triggerDate = PrePreDateinDate! + 36000 + 14400 + 21600
        TodayTomorrow = "bis Übermorgen unterschrieben abgeben."
        print("\(triggerDate) this is the TriggerDate")
            
        } else if DateSegmentedControl.selectedSegmentIndex == 1 && TimeSegmentedControl.selectedSegmentIndex == 0 {
            
        triggerDate = PreDateinDate! + 36000
        TodayTomorrow = "bis Morgen unterschrieben abgeben."
        print("\(triggerDate) this is the TriggerDate")
            
        } else if DateSegmentedControl.selectedSegmentIndex == 1 && TimeSegmentedControl.selectedSegmentIndex == 1 {
            
            triggerDate = PreDateinDate! + 36000 + 14400
            TodayTomorrow = "bis Morgen unterschrieben abgeben."
            print("\(triggerDate) this is the TriggerDate")
            
        } else if DateSegmentedControl.selectedSegmentIndex == 1 && TimeSegmentedControl.selectedSegmentIndex == 2 {
            
            triggerDate = PreDateinDate! + 36000 + 14400 + 21600
            TodayTomorrow = "bis Morgen unterschrieben abgeben."
            print("\(triggerDate) this is the TriggerDate")
            
        } else if DateSegmentedControl.selectedSegmentIndex == 2 && TimeSegmentedControl.selectedSegmentIndex == 0 {
            
            triggerDate = NowDateinDate! + 36000
            TodayTomorrow = "bis Heute unterschrieben abgeben."
            print("\(triggerDate) this is the TriggerDate")
            
        } else if DateSegmentedControl.selectedSegmentIndex == 2 && TimeSegmentedControl.selectedSegmentIndex == 1 {
            
            triggerDate = NowDateinDate! + 36000 + 14400 + 250 + 250 + 1000
            TodayTomorrow = "bis Heute unterschrieben abgeben."
            print("\(triggerDate) this is the TriggerDate")
            
        } else if DateSegmentedControl.selectedSegmentIndex == 2 && TimeSegmentedControl.selectedSegmentIndex == 2 {
            
            triggerDate = NowDateinDate! + 36000 + 14400 + 21600
            TodayTomorrow = "bis Heute unterschrieben abgeben."
            print("\(triggerDate) this is the TriggerDate")
            
        }
        
        
        print("\(triggerDate) this is the TriggerDate")

        
        
        
        
        
        
        
        
        
        
        
        
        
    let name = PersonLabel.text!
    let predate = DatumLabel.text!
   
    //let notification = UNNotification()
        
        
        
    // Content
    let content = UNMutableNotificationContent()
    content.title = "Absenz Errinerung"
    content.body = "\(name), du musst deine Absenz vom \(predate) \(TodayTomorrow)"
    content.sound = UNNotificationSound.default()
    content.badge = 1
    
    print(content.body)
        

        
    let dateComponent4 = Calendar.current.dateComponents([.day, .month, .year, .hour, .minute, .second], from: triggerDate)
    let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponent4, repeats: false)
    // let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
    let request = UNNotificationRequest(identifier:  UUID().uuidString, content: content, trigger: trigger)
    print(trigger)
        
        if triggerDate < Date() {
        
        // error the trigger Date already happened
            
            let alertController = UIAlertController(title: "Oops!", message: "Du willst einen Reminder für eine Absenz einrichten die bereits abgelofen ist.", preferredStyle: .alert)
            
        
            alertController.addAction(UIAlertAction(title: "Abbrechen", style: .cancel, handler: { (action: UIAlertAction!) in
               
              self.performSegue(withIdentifier: "saveReminder", sender: self)
                
            }))
            
            
            
            self.present(alertController, animated: true, completion: nil)
        
        
        
        }else {
        UNUserNotificationCenter.current().add(request, withCompletionHandler: { (error) in
                             if let error = error{
                                print("Could not create Local notification", error)
                            }else if let newdate = trigger.nextTriggerDate(){
                                print("Next notification date:", newdate)
                                print("Errinierung an")
                                }
                                }
                                    )
        

        self.performSegue(withIdentifier: "saveReminder", sender: self)
        }}

}



//    let mytrigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
//  let mytrigger = UNCalendarNotificationTrigger.init(dateMatching: triggerDate, repeats: false)


//            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
//            alertController.addAction(defaultAction)







