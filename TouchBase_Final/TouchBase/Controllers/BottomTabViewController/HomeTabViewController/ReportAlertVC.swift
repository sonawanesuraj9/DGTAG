//
//  ReportAlertVC.swift
//  TouchBase
//
//  Created by Suraj MAC3 on 18/10/16.
//  Copyright © 2016 Suraj MAC3. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class reportTableViewCell : UITableViewCell{
    
    
    @IBOutlet weak var lblTitle: UILabel!
    
}

class ReportAlertVC: UIViewController,Dimmable,UITableViewDataSource,UITableViewDelegate {

//TODO: - General
    let delObj = UIApplication.sharedApplication().delegate as! AppDelegate
    let cust :CustomClass_Dev = CustomClass_Dev()
    
    let dimLevel: CGFloat = 0.5
    let dimSpeed: Double = 0.5

    
    let reportTitleArray : [String] = ["It’s spam",
        "It’s annoying or not interesting",
        "irrelevant post"]
    var postID : String = String()
    var selectedReason : String = String()
//TODO: - Controls

    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var tblMain: UITableView!
    
//TOOD: - Let's Code
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.tblMain.tableFooterView = UIView()
        
         self.mainView.layer.cornerRadius = 10
        self.mainView.clipsToBounds = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//TODO: - UITableViewDatasource Method implementation
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
      return reportTitleArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCellWithIdentifier("CellID", forIndexPath: indexPath) as! reportTableViewCell
       // cell.selectionStyle = .None
        
        
        cell.lblTitle.text = reportTitleArray[indexPath.row]
        
        return cell
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("indepath:\(indexPath.row)")
        
        selectedReason = reportTitleArray[indexPath.row]
        
    }
    
//TODO: - UIButton Action
    
    @IBAction func btnSubmitClick(sender: AnyObject) {
        //TODO: Web service / API implementation
        if(selectedReason == ""){
            GeneralUI.alert("Select Reason first")
        }else{
            reportProblem()
        }
    }
    
    @IBAction func btnCancelClick(sender: AnyObject) {
        //
    }
    
    
//TODO: - Web service / API implementation
    
    /**
     Web service call to all information related to login user
     */
    func reportProblem() {
        let userID = General.loadSaved("user_id")
        let userToken = General.loadSaved("user_token")
        print("postIDassasa>>\(postID)")
        print("reason:\(self.selectedReason)")
        self.cust.showLoadingCircle()
        
        Alamofire.request(.POST, Urls_UI.REPORT_POST, parameters: ["userid":userID, "token_id":userToken,"post_id":postID,"reason":self.selectedReason])
            .responseJSON { response in
                
                switch response.result {
                case .Success:
                    if let value = response.result.value {
                        
                          self.cust.hideLoadingCircle()
                        
                        let json = JSON(value)
                        print("json for REPORT_POST:\(json)")
                        if(json["status"] != "0"){
                            GeneralUI.alert(json["status"].stringValue)
                        }else{
                            GeneralUI.alert("Reported successfully")
                            self.dismissViewControllerAnimated(true, completion: nil)
                        }
                    }
                case .Failure(let error):
                    GeneralUI.alert(error.localizedDescription)
                     self.cust.hideLoadingCircle()
                    print(error)
                }
        }
    }

}
