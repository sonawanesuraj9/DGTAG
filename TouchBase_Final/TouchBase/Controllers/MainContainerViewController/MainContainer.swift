//
//  MainContainer.swift
//  TouchBase
//
//  Created by Suraj MAC3 on 29/08/16.
//  Copyright © 2016 Suraj MAC3. All rights reserved.
//

import UIKit

extension UIImage {
    func makeImageWithColorAndSize(color: UIColor, size: CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        color.setFill()
        UIRectFill(CGRectMake(0, 0, size.width, size.height))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}

class MainContainer: UITabBarController {

    let delObj = UIApplication.sharedApplication().delegate as! AppDelegate
    
    
    var lastIndex : Int  = Int()
   
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //Uncomment to do any addtional appearence
        
      //  UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName : UIColor(red: CGFloat(0.97), green: CGFloat(0.25), blue: CGFloat(0.32), alpha: CGFloat(1))], forState: UIControlState.Normal)
        
      //  UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName : UIColor(red: CGFloat(1), green: CGFloat(1), blue: CGFloat(1), alpha: CGFloat(1))], forState: UIControlState.Selected)
        
       
    }
    
//TODO: - UITabBarDelegate Method implementation
    override func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem){
        if(item.tag == 1){
              print("item.tag == 1")
        }else if(item.tag == 2){
              print("item.tag == 2")
        }else if(item.tag == 3){
              print("item.tag == 3")
        }else if(item.tag == 4){
            print("item.tag == 4")
            self.tabBarController?.selectedIndex = 2
           // self.sideMenuViewController?.presentRightMenuViewController()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

   

}
