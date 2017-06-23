//
//  NewReminder.swift
//  Klassenbuch
//
//  Created by Developing on 23.06.17.
//  Copyright © 2017 Hadorn Developing. All rights reserved.
//

import UIKit

class NewReminder: UITableViewController {

    // Outlets
    @IBOutlet weak var PersonLabel: UILabel!
    @IBOutlet weak var DatumLabel: UILabel!
    @IBOutlet weak var AbgabeDatumLabel: UILabel!
    @IBOutlet weak var DauerderAbsenzLabel: UILabel!
    
    
    
    
    // Variables
    
    var Person: String?
    var Datum: String?
    var AbgabeDatum: String?
    var DauerderAbsenz: String?
    
    var rowArray = [["1","1","1","1"],["1"],["1"],["1"]]
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    PersonLabel.text! = Person!
    DatumLabel.text! = Datum!
    DauerderAbsenzLabel.text! = DauerderAbsenz!
    
    print(Datum!)
        
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
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
 
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



}






    func sheduleNotifications(){

        






}










//
//                UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (Bool, error) in
//                    if let error = error {
//                print(error)
//                    }
//            }
//
//
//
//
//                // Alert Controller
//                let alertController = UIAlertController(title: "", message: "Um einen Tag vor der Frist informiert zu werden klicke auf Errinere mich!", preferredStyle:UIAlertControllerStyle.actionSheet)
//
//               // let AbsenzenSheet = UIAlertController(title: "", message: "\(String(describing: PersonTitle)) du musst deine Absenz vom \(String(describing: sectionTitle!)) bis am \(futureDateinString) unterschreiben lassen und abgeben.", preferredStyle: UIAlertControllerStyle.actionSheet)
//
//                let titleFont = [NSFontAttributeName: UIFont(name: "HelveticaNeue-Medium", size: 20.0)!]
//
//                let titleAttrString = NSMutableAttributedString(string: "Errinerung einrichten!", attributes: titleFont)
//
//                alertController.setValue(titleAttrString, forKey: "attributedTitle")
//                alertController.view.tintColor = UIColor.black
//
//
//
//                alertController.addAction(UIAlertAction(title: "Errinere mich!", style: .default, handler: { (action: UIAlertAction!) in
//
//
//                // Content
//                let content = UNMutableNotificationContent()
//                content.title = "Absenz Errinerung"
//                content.body = "\(String(describing: PersonTitle)), Morgen ist die Absenz vom \(String(describing: sectionTitle!)) abzugeben."
//                    // content.categoryIdentifier = "myCategory"
//                content.sound = UNNotificationSound.default()
//                content.badge = 1
//
//
//
//
//                let mydate = ((NSDate() as Date) as Date) + (futureDateinDate?.timeIntervalSince(Date()))! - 36000 - 86400
//
//                let dateComponent = Calendar.current.dateComponents([.day, .month, .year, .hour, .minute, .second], from: mydate)
//                let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponent, repeats: false)
//
//
//                // For Developing only
//                //let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
//
//
//                let request = UNNotificationRequest(identifier: "Absenzen Timer Fertig", content: content, trigger: trigger)
//
//                UNUserNotificationCenter.current().add(request, withCompletionHandler: { (error) in
//                    if let error = error{
//                    print("Could not create Local notification", error)
//                    }else if let date = trigger.nextTriggerDate(){
//                    print("Next notification date:", date)
//                    print("Errinierung an")
//                    }
//                    }
//                        )
//
//
//                    }))
//
//                    alertController.addAction(UIAlertAction(title: "Alle Errinerungen stoppen!", style: .destructive, handler: { (action: UIAlertAction!) in
//                    print("Alle Reminder stoppen Tapped")
//
//                        // Stop all reminders
//                        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
//
//                    }))
//
//
//                alertController.addAction(UIAlertAction(title: "Abbrechen", style: .cancel, handler: { (action: UIAlertAction!) in
//                        print("Abbrechen Tapped")
//                            }))
//
//                self.present(alertController, animated: true, completion: nil)
