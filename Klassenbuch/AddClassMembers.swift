//
//  AddClassMembers.swift
//  Klassenbuch
//
//  Created by Developing on 26.08.17.
//  Copyright © 2017 Hadorn Developing. All rights reserved.
//

import UIKit
import Firebase

class AddClassMembers: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    //Variables
    //Pass this Value from ClassSelection
    var myClass = "N5aFS18"
    var Vorname = String()
    var Nachname = String()
    var Name = String()
    var Classmembers : [String] = []
    var Classlistt = ["asdsad","asasdsadd"]
    var handle2 : FIRDatabaseHandle?
    var ref2: FIRDatabaseReference?
    
    //Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var ClassNameLabel: UILabel!
    @IBOutlet weak var VornameTextField: UITextField!
    @IBOutlet weak var NachnameTextField: UITextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ClassNameLabel.text = myClass
        self.hideKeyboardWhenTappedAround()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        ref2 = FIRDatabase.database().reference()
       
        handle2 = ref2?.child("KlassenMitglieder/\(myClass)").observe(.childAdded, with: { (snapshot2) in
            
            
            if let item2 = snapshot2.value as? String{
                self.Classmembers.insert(item2, at: 0)   //.append(item2)
                self.tableView.reloadData()
                
            }
        }
            
        
        )
        print(Classmembers)
        tableView.reloadData()
    }



    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    @IBAction func AddClassMemberAction(_ sender: Any) {
   
        
        Name = "\(VornameTextField.text!) \(NachnameTextField.text!)"
       
        
        if VornameTextField.text != "" || NachnameTextField.text != "" {
        
         self.ref2?.child("KlassenMitglieder/\(myClass)").childByAutoId().setValue(Name.lowercased())
        print("uploaded")
            
            VornameTextField.text = ""
            NachnameTextField.text = ""
        }
    
    }
    
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return Classmembers.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        cell.textLabel?.text = Classmembers[indexPath.row]
        

        return cell
    }
   

    @IBAction func FinishSetup(_ sender: Any) {
        
        // Nach Double Check mit jeweiligen Informationen
        self.performSegue(withIdentifier: "FinishSetup", sender: nil)
        
        
        
    }

   
    // Override to support editing the table view.
     func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            
            
           // tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    



}
