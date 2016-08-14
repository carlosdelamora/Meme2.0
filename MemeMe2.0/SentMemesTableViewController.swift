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
    
    
}