//
//  CustomAlertVC.swift
//  TouchBase
//
//  Created by Suraj MAC3 on 27/09/16.
//  Copyright © 2016 Suraj MAC3. All rights reserved.
//

import UIKit

class CustomAlertVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.clearColor()
        
        print("Received here")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func btnEditPostClick(sender: AnyObject) {
    }

    @IBAction func btnDeletepostClick(sender: AnyObject) {
    }
}
