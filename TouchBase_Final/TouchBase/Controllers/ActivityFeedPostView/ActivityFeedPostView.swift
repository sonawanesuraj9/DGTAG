//
//  MyCustomView.swift
//  CustomSubViewFromXIB
//
//  Created by Sergey Kargopolov on 2015-04-05.
//  Copyright (c) 2015 Sergey Kargopolov. All rights reserved.
//

import UIKit

@IBDesignable class ActivityFeedPostView: UIView {
   
    
    @IBOutlet weak var btnCommentNames: UIButton!
    @IBOutlet weak var btnLikeNames: UIButton!
    
    @IBOutlet weak var lblCommentName: UILabel!
    @IBOutlet weak var lblLikeName: UILabel!
    @IBOutlet weak var blackView: UIView!
    @IBOutlet weak var lblContent: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var myImage: UIImageView!
    @IBOutlet weak var myButton: UIButton!
    
   // @IBOutlet weak var btnMoreOption: UIButton!
    @IBOutlet weak var btnComment: UIButton!
    
    
    //MARK:  User personal
    
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var btnMore: UIButton!
    @IBOutlet weak var imgDogTag: UIImageView!
    @IBOutlet weak var lblFullname: UILabel!
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var lblCountry: UILabel!
    @IBOutlet weak var imgFlag: UIImageView!
    @IBOutlet weak var lblBranch: UILabel!
    
    var view:UIView!
    
    
    @IBInspectable var mytitleLabelText: String?
    {
        get
        {
           return titleLabel.text
        }
        
        set(mytitleLabelText)
        {
            titleLabel.text = mytitleLabelText
        }
    }
    
    
    @IBInspectable var myCustomImage:UIImage?
   {
        get
        {
            return myImage.image
        }
        
        set(myCustomImage)
        {
            myImage.image = myCustomImage
        }
    }
    
    
    
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        setup()
    }
    
    required init(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)!
        setup()
    }
    
    
    func setup()
    {
        view = loadViewFromNib()
        view.frame = bounds
        view.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        
        addSubview(view)
    }
    
    
    func loadViewFromNib() -> UIView
    {
        let bundle = NSBundle(forClass:self.dynamicType)
        let nib = UINib(nibName: "ActivityFeedPostView", bundle: bundle)
        let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
        
        return view
    }

    

}
