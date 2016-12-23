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
        
        previewImage.image = meme.memedImage
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        button.viewController = self
        navigationItem.rightBarButtonItem = button.createMemeButton()
        button.meme = meme
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
