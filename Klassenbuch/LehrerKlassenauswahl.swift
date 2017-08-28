//
//  LehrerKlassenauswahl.swift
//  Klassenbuch
//
//  Created by Developing on 27.08.17.
//  Copyright © 2017 Hadorn Developing. All rights reserved.
//

import UIKit
import Firebase

class LehrerKlassenauswahl: UITableViewController {

    var ClassList : [String] = []
    var handle : FIRDatabaseHandle?
    var ref: FIRDatabaseReference?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.separatorStyle = .none
        ref = FIRDatabase.database().reference()
        handle = ref?.child("users/Klassen").observe(.childAdded, with: { (snapshot) in
            
            
            if let item = snapshot.value as? String{
                self.ClassList.append(item)
                self.tableView.reloadData()
                
            }
        }
            
            
        )
        
        
        handle = ref?.child("users/Klassen").observe(.childRemoved, with: { (snapshot) in
            
            
            if let item2 = snapshot.value as? String{
                
                
                
                
                if let i = self.ClassList.index(where: {$0 == (item2) }) {
                    self.ClassList.remove(at: i)
                    self.tableView.reloadData()
                }
                
            }
        })  }
    
    
    
    // MARK: - Table view data source
    
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return ClassList.count
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let BGimage = #imageLiteral(resourceName: "Background")
        UINavigationBar.appearance().backgroundColor = UIColor(red:0.08, green:0.17, blue:0.41, alpha:1.0)
        let backgroundImage = UIImageView(image: BGimage)
        self.tableView.backgroundView = backgroundImage
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.light)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = backgroundImage.bounds
        
        backgroundImage.addSubview(blurView)}
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        //let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        
        cell.textLabel?.text = ClassList[indexPath.row]
        cell.textLabel?.numberOfLines = 0
        cell.accessoryType = .disclosureIndicator
        
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let user = FIRAuth.auth()?.currentUser
        let uid = user?.uid
       
        let selectedClass = self.ClassList[indexPath.row]
        
        let actionSheet = UIAlertController(title: "", message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        
        let titleFont = [NSFontAttributeName: UIFont(name: "HelveticaNeue-Medium", size: 20.0)!]
        
        let titleAttrString = NSMutableAttributedString(string: "Sind Sie wirklich die Lehrperson der \(selectedClass) Klasse?", attributes: titleFont)
        
        
        actionSheet.setValue(titleAttrString, forKey: "attributedTitle")
        
        
        
        
        let logoutAction = UIAlertAction(title: "Ja", style: UIAlertActionStyle.destructive) { (alert:UIAlertAction) -> Void in
           

            self.ref?.child("users").child("Lehrer").child(uid!).updateChildValues(["Klasse": selectedClass])
            
            self.performSegue(withIdentifier: "Classsynced", sender: self)
        }
        
        let cancelAction = UIAlertAction(title: "Abbrechen", style: UIAlertActionStyle.cancel) { (alert:UIAlertAction) -> Void in
            print("Cancel Pressed")
        }
        
        actionSheet.addAction(logoutAction)
        
        actionSheet.addAction(cancelAction)
        
        self.present(actionSheet, animated: true, completion: nil)

        
        
    }
    


}
