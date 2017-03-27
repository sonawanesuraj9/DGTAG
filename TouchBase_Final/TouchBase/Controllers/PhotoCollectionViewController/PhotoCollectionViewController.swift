//
//  PhotoCollectionViewController.swift
//  TouchBase
//
//  Created by Suraj MAC3 on 06/09/16.
//  Copyright © 2016 Suraj MAC3. All rights reserved.
//

import UIKit

class PhotoCollectionViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource {

//TODO: - General
    let delObj = UIApplication.sharedApplication().delegate as! AppDelegate
    
//TODO: - Controls
    
    @IBOutlet weak var btnBackOutlet: UIButton!
    @IBOutlet weak var mainCollection: UICollectionView!
//TODO: - Let's Code
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        self.btnBackOutlet.setImage(UIImage(named: "btn_back\(self.delObj.deviceName)"), forState: UIControlState.Normal)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//TODO: - UICollectionViewDatasource Method implementation
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return 50
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell{
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("CellID", forIndexPath: indexPath) as! PhotoCollectionViewCell
        cell.imgPic.image = UIImage(named: "mil.jpg")
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        print(indexPath.row)
        
        let detailVC = self.storyboard?.instantiateViewControllerWithIdentifier("idCollectionDetailViewController") as! CollectionDetailViewController
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
    func collectionView(collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                               sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        let size = CGSizeMake(UIScreen.mainScreen().bounds.width*0.312,UIScreen.mainScreen().bounds.width*0.312)
        //CGMakeSize(UIScreen.mainScreen().bounds.height * 0.176,UIScreen.mainScreen().bounds.height * 0.176)
        return size
    }
    
//TODO: - UIButton Action
    
    @IBAction func btnBackClick(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
}
