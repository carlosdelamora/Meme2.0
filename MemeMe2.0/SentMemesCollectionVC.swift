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
    
    var memes: [MemeModel] {
        return (UIApplication.sharedApplication().delegate as! AppDelegate).memes
    }
    

    @IBAction func collectionToMeme1(sender: AnyObject) {
        let meme1 = storyboard!.instantiateViewControllerWithIdentifier("Meme1.0")
        //self.navigationController?.navigationBarHidden = true
        //navigationController!.pushViewController(meme1, animated: true)
        navigationController!.presentViewController(meme1, animated: true, completion: nil)
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

}