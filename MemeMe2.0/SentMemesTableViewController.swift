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
    
   
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        //make Sure the tab bar is present and navigation bar are present 
        self.tabBarController?.tabBar.hidden = false
        self.navigationController?.navigationBarHidden = false
        
    }
    
    
    
    //present the controller and start the app as if it was Meme1.0
    @IBAction func meme1(sender: AnyObject) {
        let memeController = storyboard!.instantiateViewControllerWithIdentifier("Meme1.0")
        //self.navigationController!.presentViewController(memeController, animated: true, completion: nil)
        //Hide the bar with the back button and the tab Bar
        navigationController?.navigationBarHidden = true
        tabBarController?.tabBar.hidden = true 
        self.navigationController!.pushViewController(memeController, animated: true)
    }
    
    //get the number of rows
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }
   
    //populate the cell
    override func tableView(tableView: UITableView,  cellForRowAtIndexPath indexPath: NSIndexPath)-> UITableViewCell {
        //obtain a cell of type Table Cell
        let cell = tableView.dequeueReusableCellWithIdentifier("tableCell") as! TableCell
        let meme = memes[indexPath.row]
        cell.tableCellImageView.image = meme.memedImage
        cell.tableCellLabel.text = meme.topText + " " + meme.bottomText
        
        return cell
    }
    
    //push the detail view controller when the meme is selected
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let controller = storyboard!.instantiateViewControllerWithIdentifier("Detail") as! DetailViewController
       
        let meme = memes[indexPath.row]
        controller.meme = meme
        //set the titile of the back button
        let backButton = UIBarButtonItem()
        backButton.title = "Table View Controller"
        navigationItem.backBarButtonItem = backButton
        navigationController?.pushViewController(controller, animated: true)
        
        
    }
    
    
}