//
//  ViewFunc.swift
//  DogTags
//
//  Created by Vijayakumar on 12/24/15.
//  Copyright © 2015 Vijayakumar. All rights reserved.
//


import UIKit

class ViewFunc {

    
    static func addNodataLabel(view: UIView, noDataLbl: UILabel, text: String) {
        
        noDataLbl.center = CGPointMake(view.frame.width/2, view.frame.height/2)
        noDataLbl.textAlignment = NSTextAlignment.Center
        noDataLbl.text = text
        noDataLbl.font = UIFont(name: "Lato-Regular", size: 17)
        view.addSubview(noDataLbl)
        
    }
    
}
