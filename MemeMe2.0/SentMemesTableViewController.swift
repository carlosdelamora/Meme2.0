//
//  SentMemesTableViewController.swift
//  MemeMe2.0
//
//  Created by Carlos De la mora on 8/11/16.
//  Copyright © 2016 Carlos De la mora. All rights reserved.
//

import Foundation
import UIKit

class SentMemesTableViewController: UITableViewController {
    
    var memes: [MemeModel] {
        return (UIApplication.sharedApplication().delegate as! AppDelegate).memes
    }
   
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBarHidden = false
    }
    
    @IBAction func meme1(sender: AnyObject) {
        let memeController = storyboard!.instantiateViewControllerWithIdentifier("Meme1.0")
        self.navigationController!.presentViewController(memeController, animated: true, completion: nil)
    }
    
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }
   
    
    override func tableView(tableView: UITableView,  cellForRowAtIndexPath indexPath: NSIndexPath)-> UITableViewCell {

        let cell = tableView.dequeueReusableCellWithIdentifier("tableCell")!
        let meme = memes[indexPath.row]
        
        cell.imageView?.image = meme.memedImage
        cell.textLabel?.text = meme.topText + " " + meme.bottomText
       
        return cell
    }
    
    
    
}