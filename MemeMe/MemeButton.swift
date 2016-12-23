//
//  Navigation.swift
//  MemeMe
//
//  Created by Worship Computer on 12/2/16.
//  Copyright © 2016 Mark Tapia. All rights reserved.
//

import Foundation
import UIKit


//Class for create/edit meme button
class MemeButton: NSObject {
    
    var viewController: UIViewController?
    var meme: Meme?
    
    //Function that returns button with correct system
    //system item
    func createMemeButton() -> UIBarButtonItem {
        
        var systemItem: UIBarButtonSystemItem
        
        //Change button image based off of VC it is in
        if viewController is PreviewViewController {
            //For Preview VC
            systemItem = .edit
        } else {
            //For Table and Collection VCs
            systemItem = .add
        }

        return UIBarButtonItem(barButtonSystemItem: systemItem, target: self, action: #selector(openMemeCreator))
    }
    
    //Function that opens create meme view
    @objc func openMemeCreator() {
        
        //Instatiate Create Meme View
        if let vc = viewController?.storyboard?.instantiateViewController(withIdentifier: "CreateMeme") as? ViewController {
            
            //Hide bottom bar only when pushed from tab
            //view controller
            if viewController is PreviewViewController {
                vc.hidesBottomBarWhenPushed = false
            } else {
                vc.hidesBottomBarWhenPushed = true
            }
            
            //If meme is set the in current view controller,
            //then send that info to the create meme view controller,
            //otherwise, set it as an empty meme
            if let currentMeme = meme {
                vc.meme = currentMeme
            } else {
                vc.meme = Meme()
            }
            
            let navCon = UINavigationController(rootViewController: vc)
            
            viewController?.present(navCon, animated: true, completion: nil)
            
            meme = nil
        }
    }
    
}
