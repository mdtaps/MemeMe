//
//  Navigation.swift
//  MemeMe
//
//  Created by Worship Computer on 12/2/16.
//  Copyright © 2016 Mark Tapia. All rights reserved.
//

import Foundation
import UIKit

private let title = "Create Meme"

class MemeButton: NSObject {
    
    var viewController: UIViewController?
    
    func createMemeButton() -> UIBarButtonItem {
        
        return UIBarButtonItem(title: title, style: .plain, target: self, action: #selector(openMemeCreator))
    }
    
    @objc private func openMemeCreator() {
        if let vc = viewController?.storyboard?.instantiateViewController(withIdentifier: "CreateMeme") as? ViewController {
            
            
            vc.hidesBottomBarWhenPushed = true
            viewController?.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
