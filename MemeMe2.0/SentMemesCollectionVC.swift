//
//  SentMemesCollectionVC.swift
//  MemeMe2.0
//
//  Created by Carlos De la mora on 8/11/16.
//  Copyright © 2016 Carlos De la mora. All rights reserved.
//

import Foundation
import UIKit

class SentMemesCollectionVC: UICollectionViewController {
    
    
    
    
    @IBOutlet weak var layoutFlow: UICollectionViewFlowLayout!
   
    var memes: [MemeModel] {
        return (UIApplication.sharedApplication().delegate as! AppDelegate).memes
    }
    
   

    @IBAction func collectionToMeme1(sender: AnyObject) {
        let meme1 = storyboard!.instantiateViewControllerWithIdentifier("Meme1.0")
        //navigationController!.presentViewController(meme1, animated: true, completion: nil)
        //Hide the bar with the back button
        navigationController?.navigationBarHidden = true
        tabBarController?.tabBar.hidden = true
        
        navigationController!.pushViewController(meme1, animated: true)
    }
    
    override func viewWillAppear(animated: Bool) {
       
        let spacex: CGFloat = 0.5
        let spacey: CGFloat = 0.5
        
        let dimensionx = (self.view.frame.width -  2*spacex)/3
        layoutFlow.minimumLineSpacing = spacey
        layoutFlow.minimumInteritemSpacing = spacex
        if self.view.frame.width < self.view.frame.height{
            layoutFlow.itemSize = CGSizeMake( dimensionx , dimensionx)}
        else{
            layoutFlow.itemSize = CGSizeMake( dimensionx/1.5 , dimensionx/1.5)
        }
        
        //make Sure the tab bar is present and navigation bar are present
        self.tabBarController?.tabBar.hidden = false
        self.navigationController?.navigationBarHidden = false
    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransitionToSize( size, withTransitionCoordinator: coordinator)
        
        
        let spacex: CGFloat = 0.5
        let spacey: CGFloat = 0.5
        let dimensionx = (size.width - 2*spacex)/3
       
        layoutFlow.minimumLineSpacing = spacey
        layoutFlow.minimumInteritemSpacing = spacex
        if size.width < size.height{
            layoutFlow.itemSize = CGSizeMake( dimensionx , dimensionx)}
        else{
            layoutFlow.itemSize = CGSizeMake( dimensionx/1.5 , dimensionx/1.5)
        }
        
    }
    

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       return memes.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("collectionCell", forIndexPath: indexPath) as! CollectionCell
        let meme = memes[indexPath.row]
        cell.collectionCellImage.image = meme.memedImage
        return cell
    }
    
    //push the Detail View Controller when the meme is selected
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        let controller = storyboard?.instantiateViewControllerWithIdentifier("Detail") as! DetailViewController
        let meme = memes[indexPath.row]
        controller.meme = meme
        
        //set the title of the back button
        let leftBackButton = UIBarButtonItem()
        leftBackButton.title = "Collection View"
        navigationItem.backBarButtonItem = leftBackButton
        navigationController?.pushViewController(controller, animated: true)
        
    }
}