//
//  KlassenInfo.swift
//  Klassenbuch
//
//  Created by Developing on 06.02.17.
//  Copyright © 2017 Hadorn Developing. All rights reserved.
//

import UIKit

class KlassenInfo: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
        // Left Swipe
        let edgePan = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(screenEdgeSwiped))
        edgePan.edges = .left
        
        view.addGestureRecognizer(edgePan)
        
           }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
           }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }
    
    
    //Fund for Left Swipe
    
    func screenEdgeSwiped(_ recognizer: UIScreenEdgePanGestureRecognizer) {
        
        if recognizer.state == .recognized {
            self.dismiss(animated: true, completion: nil)
            
        }
    }
    
    // Cancel
    
    @IBAction func cancelMitglieder (_ segue:UIStoryboardSegue) {
        
    }
    
    @IBAction func cancelKlasse (_ segue:UIStoryboardSegue) {
        
    }



}
