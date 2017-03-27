//
//  OtherUserPostVC.swift
//  TouchBase
//
//  Created by Suraj MAC3 on 10/09/16.
//  Copyright © 2016 Suraj MAC3. All rights reserved.
//

import UIKit

class OtherUserPostVC: UIViewController {

    
//TODO: - General
    
     let delObj = UIApplication.sharedApplication().delegate as! AppDelegate
//TODO: - Controls
    @IBOutlet weak var tblMain: UITableView!
    
//TODO: - Let's Code
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
//TODO: - UITableViewDatasource method implementation
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return 10
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCellWithIdentifier("CellID", forIndexPath: indexPath) as! HomeTableViewCell
        
        cell.btnLikes.setImage(UIImage(named: "img_star\(self.delObj.deviceName)"), forState: UIControlState.Normal)
        cell.btnComment.setImage(UIImage(named: "btn_comment\(self.delObj.deviceName)"), forState: UIControlState.Normal)
        cell.btnShare.setImage(UIImage(named: "img_upload\(self.delObj.deviceName)"), forState: UIControlState.Normal)
        cell.lblPost.text = "1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently"
        return cell
    }
    
  

}
