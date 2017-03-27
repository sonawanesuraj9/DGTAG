//
//  UpgradeAlertVC.swift
//  TouchBase
//
//  Created by Suraj MAC3 on 27/09/16.
//  Copyright © 2016 Suraj MAC3. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import StoreKit
import Mixpanel

class UpgradeAlertVC: UIViewController,Dimmable,SKProductsRequestDelegate,SKPaymentTransactionObserver {

//TODO: - General
    let delObj = UIApplication.sharedApplication().delegate as! AppDelegate
    let cust : CustomClass_Dev = CustomClass_Dev()
    
    let dimLevel: CGFloat = 0.5
    let dimSpeed: Double = 0.5
    
    
    //IAP
    var productIDs: Array<String!> = []
    
    var productsArray: Array<SKProduct!> = []
    
    
//TODO: - Controls
    
    @IBOutlet weak var btnCancelOutlet: UIButton!
    @IBOutlet weak var mainView: UIView!
//TODO: - Let;s code
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.mainView.layer.cornerRadius = 10
       
        
        //IAP
        //MARK: Uncomment to do Renewable
        productIDs.append("com.development.dogtagsApp")
        
       // productIDs.append("com.consumable.development")
        
        
        requestProductInfo()
        
        SKPaymentQueue.defaultQueue().addTransactionObserver(self)
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
//TODO: - IAP
    func requestProductInfo() {
        if SKPaymentQueue.canMakePayments() {
            let productIdentifiers = NSSet(array: productIDs)
            let productRequest = SKProductsRequest(productIdentifiers: productIdentifiers as! Set<String> )
            
            productRequest.delegate = self
            productRequest.start()
        }
        else {
            print("Cannot perform In App Purchases.")
        }
    }
    
    
    func paymentQueue(queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch transaction.transactionState {
            case SKPaymentTransactionState.Purchased:
                print("Transaction completed successfully >>  \(transaction.transactionIdentifier)")
                General.saveData("1", name: "is_paid")
                SKPaymentQueue.defaultQueue().finishTransaction(transaction)
                
                let uid = General.loadSaved("user_id")
                Mixpanel.mainInstance().identify(distinctId: uid)
                Mixpanel.mainInstance().track(event: "Revenue",
                                              properties: ["Revenue" : "Revenue"])

                // 1. Upgrade API
                
               
               let user_id = General.loadSaved("user_id")
                let token = General.loadSaved("user_token")
                 let ammount = "4.99"
                let transactionID = ""
                let params: [String: AnyObject] = ["user_id": user_id, "token_id": token,"transaction_id":transactionID,"amount":ammount ]
                upgradeMembership(params)
                self.view.endEditing(true)
                
                
                
            case SKPaymentTransactionState.Failed:
                print("Transaction Failed");
                SKPaymentQueue.defaultQueue().finishTransaction(transaction)
                
                
            default:
                print(transaction.transactionState.rawValue)
            }
        }
    }
    
    /*func productsRequest (request: SKProductsRequest, didReceiveResponse response: SKProductsResponse) {
        
        let count : Int = response.products.count
        if (count>0) {
            let validProduct: SKProduct = response.products[0] as SKProduct
            if (validProduct.productIdentifier == self.productIDs[0]) {
                print(validProduct.localizedTitle)
                print(validProduct.localizedDescription)
                print(validProduct.price)                
            } else {
                print(validProduct.productIdentifier)
            }
        } else {
            print("nothing")
        }
    }*/
    
    
//TODO: -  SKPaymentTransactionObserver States
    
    func paymentQueue(queue: SKPaymentQueue, removedTransactions transactions: [SKPaymentTransaction]){
        print("queue:\(queue)")
        print("transactions:\(transactions)")
        
    }
    
    func paymentQueue(queue: SKPaymentQueue, updatedDownloads downloads: [SKDownload]){
        
    }
   
//TODO: Delegate method implementation
    
    func productsRequest(request: SKProductsRequest, didReceiveResponse response: SKProductsResponse) {
        if response.products.count != 0 {
            for product in response.products {
                productsArray.append(product )
            }
            //tblProducts.reloadData()
            if response.invalidProductIdentifiers.count != 0 {
                print(response.invalidProductIdentifiers.description)
            }
        }
        else {
            print("There are no products.")
        }
        
       
    }
    
    
    

//TODO: - UIButton Action
    
   
    
    @IBAction func btnBuyClick(sender: AnyObject) {
        
        let tmpStat = General.loadSaved("is_paid")
        if(tmpStat == "1"){
            GeneralUI.alert("You have Premium Membership")
        }else{
        
            if(self.productsArray.count>0){
                let payment = SKPayment(product: self.productsArray[0] as SKProduct)
                SKPaymentQueue.defaultQueue().addPayment(payment)
            }else{
                GeneralUI.alert("Please wait")
            }
        }
        
        //GeneralUI.alert("Buy button click ")
    }
    
    
//TODO: - Web service / API implementation
    
    
    func upgradeMembership(params: [String: AnyObject]) {
        
        self.view.userInteractionEnabled = false
        print(params)
        self.cust.showLoadingCircle()
        Alamofire.upload(.POST, Urls_UI.UPGRADE_MEMBERSHIP, multipartFormData: {
            multipartFormData in
            
            for (key, value) in params {
                multipartFormData.appendBodyPart(data: value.dataUsingEncoding(NSUTF8StringEncoding)!, name: key)
            }
            }, encodingCompletion: {
                encodingResult in
                
                switch encodingResult {
                case .Success(let upload, _, _):
                    upload.responseJSON {
                        response in
                        self.view.userInteractionEnabled = true
                        self.cust.hideLoadingCircle()
                        switch response.result {
                        case .Success:
                            if let value = response.result.value {
                                let json = JSON(value)
                                
                                print("JSON: \(json)")
                                
                                if let status = json["status"].string {
                                    if status != "0" {
                                        GeneralUI_UI.alert(json["message"].string!)
                                    } else {
                                        self.btnCancelOutlet.sendActionsForControlEvents(.TouchUpInside)
                                       
                                        print("You are in successful block")
                                        
                                    }
                                }
                                
                            }
                        case .Failure(let error):
                            GeneralUI_UI.alert(error.localizedDescription)
                            print(error)
                        }
                        
                        
                    }
                case .Failure(let encodingError):
                    print(encodingError)
                }
        })
    }
    
    
    
}
