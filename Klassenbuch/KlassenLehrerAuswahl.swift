//
//  KlassenLehrerAuswahl.swift
//  Klassenbuch
//
//  Created by Developing on 30.08.17.
//  Copyright © 2017 Hadorn Developing. All rights reserved.
//

import UIKit
import Firebase

class KlassenLehrerAuswahl: UITableViewController {

    // array sollte Downgelodet werden mit allen Lehrer Namen vlt.
    var KlassenLehrerArray = ["martine vetterli", "Joachim bruder"]
    var handle : FIRDatabaseHandle?
    var ref: FIRDatabaseReference?
    var myKlasse = String()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

       
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



    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return KlassenLehrerArray.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        cell.textLabel?.text = KlassenLehrerArray[indexPath.row]
        cell.textLabel?.numberOfLines = 0
        cell.accessoryType = .disclosureIndicator

        return cell
    }
  

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    
    // Lehrer uf de Tippt wird wird KlasseLehrer, nach Firebase gschribe zum einte wer de Lehrer isch zum andere au das die Klass en Lehrer besitzt. Denn gits en Segue zrug und dete setts Label updatet werde.
        
     let SelectedTeacher = self.KlassenLehrerArray[indexPath.row]
        
        let user = FIRAuth.auth()?.currentUser
        let uid = user?.uid
        
        let actionSheet = UIAlertController(title: "", message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        
        let titleFont = [NSFontAttributeName: UIFont(name: "HelveticaNeue-Medium", size: 20.0)!]
        
        let titleAttrString = NSMutableAttributedString(string: "Ist \(SelectedTeacher)  wirklich der KlassenLehrer ihrer Klasse?", attributes: titleFont)
        
        
        actionSheet.setValue(titleAttrString, forKey: "attributedTitle")
        
        
        
        
        let logoutAction = UIAlertAction(title: "Ja", style: UIAlertActionStyle.destructive) { (alert:UIAlertAction) -> Void in
            
            
            // Check ischer Student vo de Klass???
            
            self.ref = FIRDatabase.database().reference()
            
            
            self.ref?.child("users").child("Schüler").child(uid!).child("Klasse").observe(.value, with: { (snapshot) in
                
                
                if let item3 = snapshot.value as? String{
                    
                    
                    self.myKlasse = item3
                    
                    
                    self.ref?.child("users").child("KlassenEinstellungen").child(self.myKlasse).updateChildValues(["HatKlassenLehrer": true])
                   
                    // Settich uploade d Email, de Name oder de Name us em Lehrer Name Array?
                    self.ref?.child("users").child("KlassenEinstellungen").child(self.myKlasse).updateChildValues(["KlassenLehrer": SelectedTeacher])
                    
                    self.performSegue(withIdentifier: "backfromTeacherselectionSegue", sender: self)
               
                
                
//            })
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
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
