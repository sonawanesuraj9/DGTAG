//
//  PostDetailContainerViewController.swift
//  TouchBase
//
//  Created by Suraj MAC3 on 01/09/16.
//  Copyright © 2016 Suraj MAC3. All rights reserved.
//

import UIKit

class PostDetailContainerViewController: UIViewController {

//TODO: - General
    let delObj = UIApplication.sharedApplication().delegate as! AppDelegate
    
//TODO: - Controls
    
    @IBOutlet weak var btnBack: UIButton!
//TODO: - Let's Code    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        self.btnBack.setImage(UIImage(named: "btn_back\(self.delObj.deviceName)"), forState: UIControlState.Normal)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
//TODO: - UIButton Action
    
    @IBAction func btnBackClick(sender: AnyObject) {
        if(self.navigationController != nil){
            self.navigationController?.popViewControllerAnimated(true)
        }else{
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        
    }
    

}
