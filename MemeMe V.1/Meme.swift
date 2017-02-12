//
//  Meme.swift
//  MemeMe V.1
//
//  Created by Chi Nguyen on 1/22/17.
//  Copyright © 2017 udacity. All rights reserved.
//

import Foundation
import UIKit

struct Meme {
    let topTextField: NSString!
    let bottomTextField:NSString!
    let image: UIImage!
    let memedImage: UIImage!
    
    init(topTextField:NSString, bottomTextField:NSString,
         image: UIImage, memedImage: UIImage){
        self.topTextField = topTextField
        self.bottomTextField = bottomTextField
        self.image = image
        self.memedImage = memedImage
    }
    
}
