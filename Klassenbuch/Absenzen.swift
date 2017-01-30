//
//  Absenzen.swift
//  Klassenbuch
//
//  Created by Developing on 11.12.16.
//  Copyright © 2016 Hadorn Developing. All rights reserved.
//

import UIKit

class Absenzen: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }


    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
  
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return 0
    }

    //UIBarButton Functions
    
    @IBAction func cancelAbsenzen (_ segue:UIStoryboardSegue) {
        
    }
    
    @IBAction func saveAbsenzen (_ segue:UIStoryboardSegue) {
        
    }

}
