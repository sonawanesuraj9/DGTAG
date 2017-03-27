//
//  ShareToViewController.swift
//  TouchBase
//
//  Created by Suraj MAC3 on 13/09/16.
//  Copyright © 2016 Suraj MAC3. All rights reserved.
//

import UIKit

class ShareToViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UITextViewDelegate {

//TODO: - General
    
    let delObj = UIApplication.sharedApplication().delegate as! AppDelegate
    let cust : CustomClass_Dev = CustomClass_Dev()
    
    let placeholderTextColor : UIColor = UIColor.lightGrayColor()
    var is_textEdited : Bool = Bool()
    
     var leftImageFrame = CGRect()
    
    var selectedIndArray : [String] = ["0","0","0","0","0","0","0"]
    var nameArray : [String] = ["Norma T. Langford","Morgan W. Edwards","Brad K. Harrison","James D. Lane","Jennifer J. Oviedo","Robert M. McDougald","Roberto M. Steele"]
    
    
//TODO: - Controls
    
    @IBOutlet weak var lblShareWith: UILabel!
    @IBOutlet weak var txtSearch: UITextField!
    @IBOutlet weak var txtMessage: UITextView!
    @IBOutlet weak var mainCollection: UICollectionView!
    @IBOutlet weak var btnSubmitOrCancelOutlet: UIButton!
//TODO: - Let's Code
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        initialize()
        initPlaceholderForTextView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    
//TODO: - Function
    
    /**
     Placeholder text for UITextView is set
     
     - returns: nothing is return
     */
    func initPlaceholderForTextView(){
        txtMessage.text = "Write a message..."
        txtMessage.textColor = placeholderTextColor
        is_textEdited = false
        txtMessage.delegate = self
        self.txtMessage.layer.borderWidth = 0.5
        self.txtMessage.layer.borderColor = placeholderTextColor.CGColor
    }
    
    /**
     UIView initialization
     
     - returns: return nothing
     */
    func initialize(){
        leftImageFrame = CGRectMake(0, 0, 30, 20)
        //1
        txtSearch.leftViewMode = UITextFieldViewMode.Always
        let FirstImageView = UIImageView(frame: leftImageFrame)
        var FirstImage = UIImage()
        FirstImageView.contentMode = .Center
        
        FirstImage = UIImage(named: "img_search-icon\(self.delObj.deviceName)")!
        FirstImageView.image = FirstImage
        txtSearch.leftView = FirstImageView
        
        self.lblShareWith.text = ""
    }
    
    /**
     Display all names to whom user sharing post
     */
    func sendToNames(){
        var names : String = String()
        if(self.selectedIndArray.count>0){
            for ind in 0...self.selectedIndArray.count-1{
                
                if(self.selectedIndArray[ind] == "1"){
                    names = names + self.nameArray[ind] + ","
                }
            }
            
        }
        
        if(names == ""){
            self.lblShareWith.hidden = true
        }else{
            self.lblShareWith.hidden = false
        }
        let basicText  = "Share with "
        let basicString = NSMutableAttributedString(string:basicText)
        basicString.addAttributes([NSForegroundColorAttributeName:UIColor.blackColor()], range: NSMakeRange(0, basicText.characters.count))
        
        let dynamicText = names
        let dynamiString = NSMutableAttributedString(string: dynamicText)
        dynamiString.addAttributes([NSForegroundColorAttributeName:UIColor(red: 3/255, green: 192/255, blue: 255/255, alpha: 1.0)], range: NSMakeRange(0, dynamicText.characters.count))
        basicString.appendAttributedString(dynamiString)
        self.lblShareWith.attributedText = basicString
        
    }
   
//TODO: - UICollectionView Delegate method implementation
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return selectedIndArray.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell{
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("CellID", forIndexPath: indexPath) as! ShareToCollectionViewCell
        
        cell.backgroundColor = UIColor.clearColor()
        //response data
        
        cell.imgDogTags.image = UIImage(named: "img_dogtagBG-small\(self.delObj.deviceName)")
        
        
        cell.lblName.text = self.nameArray[indexPath.row]
        cell.lblCountry.text = "United States"
        cell.lblSection.text = "Army"
        cell.lblLocation.text = "1440 Davis Street"
        
        cell.imgProfilePic.image = UIImage(named: "army.jpg")
        cell.imgProfilePic.layer.cornerRadius = cell.imgProfilePic.frame.size.width/2
        cell.imgProfilePic.clipsToBounds = true
        
        if(self.selectedIndArray[indexPath.row] == "0"){
            //Unselected DogTag
             cell.imgDogTags.alpha = 1.0
            cell.imgProfilePic.alpha = 1.0
            cell.stackDetail.alpha = 1.0
            
        }else{
            //Selected DogTag
            
            cell.imgDogTags.alpha = 0.4
            cell.imgProfilePic.alpha = 0.4
            cell.stackDetail.alpha = 0.4
        }
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        print(indexPath.row)
        if(self.selectedIndArray[indexPath.row] == "0"){
            //Select
            self.selectedIndArray[indexPath.row] = "1"
            
        }else{
            //Unselect
            self.selectedIndArray[indexPath.row] = "0"
        }
        
        let indexPaths = self.mainCollection.indexPathsForSelectedItems()!
       // let indx = indexPaths[0]
        self.mainCollection.reloadItemsAtIndexPaths(indexPaths)
      
        sendToNames()
    }
    
 
    
    
    
    
    
//TODO: UITextViewDelegate Methods
    
    func textViewDidBeginEditing(textView: UITextView) {
        if textView.textColor == placeholderTextColor{
            textView.text = nil
            textView.textColor = UIColor.blackColor()
            is_textEdited = true
            self.btnSubmitOrCancelOutlet.setTitle("Submit", forState: UIControlState.Normal)
        }
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        if textView == txtMessage{
            if textView.text.isEmpty{
                txtMessage.text = "Write a message..."
                txtMessage.textColor = placeholderTextColor
                is_textEdited = false
                 self.btnSubmitOrCancelOutlet.setTitle("Cancel", forState: UIControlState.Normal)
            }
            
        }
    }


//TODO: - UIButton Action
    
    @IBAction func btnSubmitClick(sender: AnyObject) {
        if(is_textEdited){
            print("Message will be sent")
            cust.displayAlert("", msg: "Post share successfully")
            
        }else{
             NSNotificationCenter.defaultCenter().postNotificationName("hideShareView", object: nil)
        }
       
    }
    

}
