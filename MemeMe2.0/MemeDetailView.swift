//
//  MemeDetailView.swift
//  MemeMe2.0
//
//  Created by Carlos De la mora on 8/17/16.
//  Copyright © 2016 Carlos De la mora. All rights reserved.
//

import Foundation
import UIKit

class DetailViewController:UIViewController {
    
    @IBOutlet weak var memeImage: UIImageView!
    var meme: MemeModel!
    
   override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        memeImage.image = meme.memedImage
        self.tabBarController?.tabBar.isHidden = true
    
    }
}


