//
//  MilIDExampleViewController.swift
//  TouchBase
//
//  Created by Suraj MAC3 on 20/11/16.
//  Copyright © 2016 Suraj MAC3. All rights reserved.
//

import UIKit

class MilIDExampleViewController: UIViewController {

    @IBOutlet weak var imgID: UIImageView!
    @IBOutlet weak var btnBackOutlet: UIButton!
    let delObj = UIApplication.sharedApplication().delegate as! AppDelegate
    var id : String = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        var composeImage : UIImage = UIImage()
        if(id == "1"){
            composeImage = UIImage(named: "example1.jpg")!
        }else if(id == "2"){
            
            composeImage = UIImage(named: "example2.jpg")!
        }
        self.imgID.image = composeImage
        self.imgID.contentMode = .ScaleAspectFit
        
        self.btnBackOutlet.setImage(UIImage(named: "btn_back\(self.delObj.deviceName)"), forState: UIControlState.Normal)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func btnBackClick(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
}
