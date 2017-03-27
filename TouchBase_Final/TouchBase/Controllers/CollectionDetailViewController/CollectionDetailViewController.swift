//
//  CollectionDetailViewController.swift
//  TouchBase
//
//  Created by Suraj MAC3 on 06/09/16.
//  Copyright © 2016 Suraj MAC3. All rights reserved.
//

import UIKit

class CollectionDetailViewController: UIViewController {

    
//TODO: - General
    let delObj = UIApplication.sharedApplication().delegate as! AppDelegate
    
    
//TODO: - Controls
    
    @IBOutlet weak var btnCommentOutlet: UIButton!
    @IBOutlet weak var btnLikesOutlet: UIButton!
    @IBOutlet weak var btnBackOutlet: UIButton!
//TODO: - Let's Code
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        self.btnBackOutlet.setImage(UIImage(named: "btn_back\(self.delObj.deviceName)"), forState: UIControlState.Normal)
        self.btnLikesOutlet.setImage(UIImage(named: "img_star\(self.delObj.deviceName)"), forState: UIControlState.Normal)
        self.btnCommentOutlet.setImage(UIImage(named: "btn_comment\(self.delObj.deviceName)" ), forState: UIControlState.Normal)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
//TODO: - UIButton Action

    @IBAction func btnBackClick(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
}
