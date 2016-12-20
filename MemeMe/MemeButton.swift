//
//  Navigation.swift
//  MemeMe
//
//  Created by Worship Computer on 12/2/16.
//  Copyright © 2016 Mark Tapia. All rights reserved.
//

import Foundation
import UIKit

class MemeButton: NSObject {
    
    var viewController: UIViewController?
    var meme: Meme?
    
    func createMemeButton() -> UIBarButtonItem {
        
        var systemItem: UIBarButtonSystemItem
        
        if viewController is PreviewViewController {
            systemItem = .edit
        } else {
            systemItem = .add
        }
        
        return UIBarButtonItem(barButtonSystemItem: systemItem, target: self, action: #selector(openMemeCreator))
    }
    
    @objc func openMemeCreator() {
        if let vc = viewController?.storyboard?.instantiateViewController(withIdentifier: "CreateMeme") as? ViewController {
            
            if viewController is PreviewViewController {
                vc.hidesBottomBarWhenPushed = false
            } else {
                vc.hidesBottomBarWhenPushed = true
            }
            
            if let currentMeme = meme {
                vc.meme = currentMeme
            } else {
                vc.meme = Meme()
            }
            
            viewController?.navigationController?.pushViewController(vc, animated: true)
            
            meme = nil
        }
    }
    
}
