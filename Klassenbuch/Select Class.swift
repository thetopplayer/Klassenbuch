//
//  Select Class.swift
//  Klassenbuch
//
//  Created by Developing on 25.08.17.
//  Copyright © 2017 Hadorn Developing. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class Select_Class: UITableViewController {

    
    @IBOutlet weak var BarButton: UIBarButtonItem!
  
    var ClassList : [String] = []
    var handle : FIRDatabaseHandle?
    var ref: FIRDatabaseReference?
    var SchülerName = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        UserDefaults.standard.set(false, forKey: "StudenthasClass")
        UserDefaults.standard.synchronize()

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
        
        backgroundImage.addSubview(blurView)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        //let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        
        cell.textLabel?.text = ClassList[indexPath.row]
        cell.textLabel?.numberOfLines = 0
        cell.accessoryType = .disclosureIndicator
       
        
        
        return cell
    }
 
 
    @IBAction func cancelClassErsellen (_ segue:UIStoryboardSegue) {
    
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        let user = FIRAuth.auth()?.currentUser
        let uid = user?.uid
        
        let selectedClass = self.ClassList[indexPath.row]
        
        let actionSheet = UIAlertController(title: "", message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        
        let titleFont = [NSFontAttributeName: UIFont(name: "HelveticaNeue-Medium", size: 20.0)!]
        
        let titleAttrString = NSMutableAttributedString(string: "Sind Sie wirklich die Schüler der \(selectedClass) Klasse?", attributes: titleFont)
        
        
        actionSheet.setValue(titleAttrString, forKey: "attributedTitle")
        
        
        
        
        let logoutAction = UIAlertAction(title: "Ja", style: UIAlertActionStyle.destructive) { (alert:UIAlertAction) -> Void in
      
           
            // Check ischer Student vo de Klass???
            
            self.ref = FIRDatabase.database().reference()
            
   
          self.ref?.child("users").child("Schüler").child(uid!).child("name").observe(.value, with: { (snapshot) in
                
                
                if let item3 = snapshot.value as? String{
                    
                    
                    self.SchülerName = item3
                    
      
            

            
           self.ref?.child("KlassenMitglieder").child(selectedClass).observeSingleEvent(of: .value, with: { (snapshot) in
                
                if snapshot.hasChild(self.SchülerName){
                    
                    print("Is a Class member")
                    
                    
                    self.ref?.child("users").child("Schüler").child(uid!).updateChildValues(["Klasse": selectedClass])
                    UserDefaults.standard.set(true, forKey: "StudenthasClass")
                    UserDefaults.standard.synchronize()
                    self.performSegue(withIdentifier: "ClassAddedStudent", sender: self)
          
                    
                }else{
                    
                    print("Isn't a Class member")
                    // error Message hey in verbindig trette mit dem und dem
                    
                    let alertController = UIAlertController(title: "Du bist nicht Mitglied dieser Klasse!", message: "Wie es aussieht bist du nicht Mitglied dieser Klasse. Melde dich bei einem deiner Kollegen, dass sie dich doch in die Klasse hinzufügen sollen!", preferredStyle: .alert)
                    
                    alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { (action: UIAlertAction!) in
                      
                        
                        
                    }))
                    self.present(alertController, animated: true, completion: nil)

                    
                    
                    
                }
                
                
            })
     
        }
 
   
            })
        }
        
        
    
    
        let cancelAction = UIAlertAction(title: "Abbrechen", style: UIAlertActionStyle.cancel) { (alert:UIAlertAction) -> Void in
            print("Cancel Pressed")
        }
        actionSheet.addAction(logoutAction)
        
        actionSheet.addAction(cancelAction)
        
        self.present(actionSheet, animated: true, completion: nil)
    }
   
    


    }


