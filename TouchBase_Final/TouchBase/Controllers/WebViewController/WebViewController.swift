//
//  WebViewController.swift
//  TouchBase
//
//  Created by Suraj MAC3 on 06/09/16.
//  Copyright © 2016 Suraj MAC3. All rights reserved.
//

import UIKit

class WebViewController: UIViewController,UIWebViewDelegate {

    
    
//TODO: - General
    let delObj = UIApplication.sharedApplication().delegate as! AppDelegate
    
    let cust : CustomClass_Dev = CustomClass_Dev()
    
    var url = "http://apple.com"
    
    
    //MARK: Index = 0 >> FAQ, 1 >> About DogTag, 2 >> Privacy Policy, 3 >> Terms and conditions
    var index : Int = Int()
    
    
//TODO: - Controls
    
    @IBOutlet weak var btnBackOutlet: UIButton!
    @IBOutlet weak var wbView: UIWebView!
//TODO: - Let's Code
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        index = self.delObj.webViewIndex
        
        if(index == 0){
           url = General.loadSaved("faq")
        }else if(index == 1){
            url = General.loadSaved("aboutDogTags")
        }else if(index == 2){
            url = General.loadSaved("privacyURL")
        }else if(index == 3){
           // url = General.loadSaved("termsURL")
             url = "\(Urls.BASE_URL)privacy-policy"//General.loadSaved("termsURL")
        }
        
        
        
        
        let requestURL = NSURL(string:url)
        let request = NSURLRequest(URL: requestURL!)
        wbView.loadRequest(request)
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        self.btnBackOutlet.setImage(UIImage(named: "btn_back\(self.delObj.deviceName)"), forState: UIControlState.Normal)
    }
    
//TODO: - UIWebViewDelegate Method implementation
    func webViewDidStartLoad(webView: UIWebView){
        self.cust.showLoadingCircle()
    }
    func webViewDidFinishLoad(webView: UIWebView){
          self.cust.hideLoadingCircle()
    }
//TODO: - UIButton Action
    
    
    @IBAction func btnBackClick(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

}
