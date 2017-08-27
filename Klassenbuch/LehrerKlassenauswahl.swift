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
        
        
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
       
        
        
        
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
    }
    
    
    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

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
