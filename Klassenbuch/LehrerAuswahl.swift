//
//  LehrerAuswahl.swift
//  Klassenbuch
//
//  Created by Developing on 27.08.17.
//  Copyright © 2017 Hadorn Developing. All rights reserved.
//

import UIKit
import Firebase

class LehrerAuswahl: UITableViewController {

    
    // Outlets
    @IBOutlet weak var SearchBar: UISearchBar!
    
    // Variables
    var Lehrer  = ["Martine","Joachim"]
    var filteredData:[String] = []
    var resultSearchController:UISearchController!
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 1
        resultSearchController = UISearchController(searchResultsController: nil)
        // 2
        resultSearchController.searchResultsUpdater = self as! UISearchResultsUpdating
        // 3
        resultSearchController.hidesNavigationBarDuringPresentation = false
        // 4
        resultSearchController.dimsBackgroundDuringPresentation = false
        // 5
        resultSearchController.searchBar.searchBarStyle = UISearchBarStyle.prominent
        // 6
        resultSearchController.searchBar.sizeToFit()
        // 7
        self.tableView.tableHeaderView = resultSearchController.searchBar
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
       
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if resultSearchController.isActive {
            return filteredData.count
        }
        else {
            return Lehrer.count
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell { let cell = tableView.dequeueReusableCell(withIdentifier: "LehrerCell", for: indexPath)
        
        // Configure the cell...
        if resultSearchController.isActive {
            cell.textLabel?.text = filteredData[indexPath.row]
        }
        else {
            cell.textLabel?.text = Lehrer[indexPath.row]
        }
        
        return cell
    }
  


}
