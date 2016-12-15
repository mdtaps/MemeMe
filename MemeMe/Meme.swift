//
//  Meme.swift
//  experiment
//
//  Created by Worship Computer on 10/17/16.
//  Copyright © 2016 Mark Tapia. All rights reserved.
//

import Foundation
import UIKit

struct Meme {
    var textTop: String
    var textBottom: String
    var image: UIImage
    var memedImage: UIImage
    
    init(textTop: String, textBottom: String, image: UIImage?, memedImage: UIImage) {
        self.textTop = textTop
        self.textBottom = textBottom
        self.memedImage = memedImage
        
        if let image = image {
            self.image = image
        } else {
            self.image = UIImage()
        }
    }
    
    init() {
        textTop = "TOP"
        textBottom = "BOTTOM"
        image = UIImage()
        memedImage = UIImage()
    }
}
