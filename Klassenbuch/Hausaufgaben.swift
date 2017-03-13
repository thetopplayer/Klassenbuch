//
//  Hausaufgaben.swift
//  Klassenbuch
//
//  Created by Developing on 11.12.16.
//  Copyright © 2016 Hadorn Developing. All rights reserved.
//  Original


import UIKit
import FirebaseDatabase
import FirebaseAuth


struct Homework {
    var HDatum: Int
    var HFach: String
    var HText: String
    var HUid: String
}


class Hausaufgaben: UITableViewController {
    
    
    // Variables
    
    var data = [Int: [Homework]]() // Date: Homework Object
    var sortedData = [(Int, [Homework])]()
    var ref: FIRDatabaseReference?
    var databaseHandle: FIRDatabaseHandle?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Setup EmtyState
        self.EmptyScreen()
        
        //Setup Onboarding
        self.FirstLoginOnboarding()
        
        tableView.allowsMultipleSelectionDuringEditing = true
        
        //TableViewCell Auto resizing
        tableView.estimatedRowHeight = 44
        tableView.rowHeight = UITableViewAutomaticDimension
        
        // Set the Firebase refrence
        ref = FIRDatabase.database().reference()
        let user = FIRAuth.auth()?.currentUser
        
        
        // Retrieve the Post and listen for Changes
        ref!.child("homeworks/\(user!.uid)").observe(.childAdded, with: { (snapshot) in
            
            if let fdata = snapshot.value as? NSDictionary {
                
                let hdatum = fdata["HDatum"] as! Int
                
                let hfach = fdata["HFach"] as! String
                
                let htext = fdata["HText"] as! String
                
                let hID = snapshot.key
                
                let homeObject = Homework(HDatum: hdatum, HFach: hfach, HText: htext, HUid: hID)
                
                if self.data[hdatum] == nil {
                    self.data[hdatum] = [homeObject]
                }else {
                    self.data[hdatum]!.append(homeObject)
                }
            }
            
            self.sortedData = self.data.sorted(by: { $0.0.key < $0.1.key})
            self.tableView.reloadData()
            self.EmptyScreen()
        })
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }

   
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return self.sortedData.count
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.sortedData[section].1.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.sortedData[section].0.convertTimestampToDate
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "HausaufgabenCell")
        cell.textLabel?.text = self.sortedData[indexPath.section].1[indexPath.row].HText
        cell.detailTextLabel?.text = self.sortedData[indexPath.section].1[indexPath.row].HFach
        cell.textLabel?.numberOfLines = 0
        return cell
    }

    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
    
        if editingStyle == UITableViewCellEditingStyle.delete{

        }
        print(indexPath.row)
}
    
    
    // Func for EmptyState
    
    func EmptyScreen () {
    
        if tableView.visibleCells.count == 0 {
            
        tableView.backgroundView = UIImageView(image: UIImage(named: "EmptyHomework"))
         tableView.separatorStyle = .none
        } else{
        tableView.backgroundView = nil
        tableView.separatorStyle = .singleLine
        }
    }
    
    
    // UIBarButtons Functions
    
    @IBAction func cancelHausaufgaben (_ segue:UIStoryboardSegue) {
    }

    @IBAction func saveHausaufgaben (_ segue:UIStoryboardSegue) {
    }
    
   
    //Login Onboarding Setup
    func FirstLoginOnboarding() {
        
        let launchedBefore = UserDefaults.standard.bool(forKey: "launchedBefore")
        if launchedBefore  {
            
            print("Not first launch.")
            
        } else {
            //User hat die App noch nicht gebraucht und bekommt einen Walkthrough
            
            let alert = UIAlertController(title: "Sieh dir die App an!", message: "Du wirst nun eine Einführung für das Klassenbuch App erhalten", preferredStyle: .alert)
            
            let action = UIAlertAction(title: "OK", style: .default) { (action) -> Void in
                self.performSegue(withIdentifier: "LoginOnboarding", sender: self)
            }
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
            
            print("First launch, setting UserDefault.")
            UserDefaults.standard.set(true, forKey: "launchedBefore")
        }
    }
   
    // Cancel App Onboarding
    
    @IBAction func cancelAppOnboarding (_ segue:UIStoryboardSegue) {
    }
}



