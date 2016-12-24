//
//  PreviewViewController.swift
//  MemeMe
//
//  Created by Worship Computer on 12/19/16.
//  Copyright © 2016 Mark Tapia. All rights reserved.
//

import UIKit

class PreviewViewController: UIViewController {

    @IBOutlet weak var previewImage: UIImageView!
    
    var meme = Meme()
    var button = MemeButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        button.viewController = self
        navigationItem.rightBarButtonItem = button.createMemeButton()
        button.meme = meme
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        previewImage.image = meme.memedImage
    }
}
