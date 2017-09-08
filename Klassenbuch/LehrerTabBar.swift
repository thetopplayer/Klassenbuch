//
//  LehrerTabBar.swift
//  Klassenbuch
//
//  Created by Developing on 08.09.17.
//  Copyright © 2017 Hadorn Developing. All rights reserved.
//

import UIKit

class LehrerTabBar: UITabBarController {

    
//    var fromDetail = Bool() == false
    var Counter = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        
//        if fromDetail == true{
//          Counter = 2
//            
//            selectedIndex = 2
//        } else{
//            selectedIndex = 0
//        }
//        
//        
//        selectedIndex = Counter
//        
//        
//        if Counter == 22 {
//        
//        Counter = 0
//        }
        
        
        
        if Counter == 0{
            
            selectedIndex = 0
            Counter = 0
        
        }else if Counter == 2{
          
            selectedIndex = 2
            Counter = 0
        
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
