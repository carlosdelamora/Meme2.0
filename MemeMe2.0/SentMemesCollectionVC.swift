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
        return (UIApplication.shared.delegate as! AppDelegate).memes
    }
    
   

    @IBAction func collectionToMeme1(_ sender: AnyObject) {
        let meme1 = storyboard!.instantiateViewController(withIdentifier: "Meme1.0")
        //navigationController!.presentViewController(meme1, animated: true, completion: nil)
        //Hide the bar with the back button
        navigationController?.isNavigationBarHidden = true
        tabBarController?.tabBar.isHidden = true
        
        navigationController!.pushViewController(meme1, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
       
        let spacex: CGFloat = 0.5
        let spacey: CGFloat = 0.5
        
        let dimensionx = (self.view.frame.width -  2*spacex)/3
        layoutFlow.minimumLineSpacing = spacey
        layoutFlow.minimumInteritemSpacing = spacex
        if self.view.frame.width < self.view.frame.height{
            layoutFlow.itemSize = CGSize( width: dimensionx , height: dimensionx)}
        else{
            layoutFlow.itemSize = CGSize( width: dimensionx/1.5 , height: dimensionx/1.5)
        }
        
        //make Sure the tab bar is present and navigation bar are present
        self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.isNavigationBarHidden = false
        
        //reload the data in case there is new memes
        self.collectionView?.reloadData()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition( to: size, with: coordinator)
        
        
        let spacex: CGFloat = 0.5
        let spacey: CGFloat = 0.5
        let dimensionx = (size.width - 2*spacex)/3
       
        layoutFlow.minimumLineSpacing = spacey
        layoutFlow.minimumInteritemSpacing = spacex
        if size.width < size.height{
            layoutFlow.itemSize = CGSize( width: dimensionx , height: dimensionx)}
        else{
            layoutFlow.itemSize = CGSize( width: dimensionx/1.5 , height: dimensionx/1.5)
        }
        
    }
    

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       return memes.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionCell", for: indexPath) as! CollectionCell
        let meme = memes[indexPath.row]
        cell.collectionCellImage.image = meme.memedImage
        return cell
    }
    
    //push the Detail View Controller when the meme is selected
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let controller = storyboard?.instantiateViewController(withIdentifier: "Detail") as! DetailViewController
        let meme = memes[indexPath.row]
        controller.meme = meme
        
        //set the title of the back button
        let leftBackButton = UIBarButtonItem()
        leftBackButton.title = "Collection View"
        navigationItem.backBarButtonItem = leftBackButton
        navigationController?.pushViewController(controller, animated: true)
        
    }
}
