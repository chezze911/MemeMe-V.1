//
//  MemeTextFieldDelegate.swift
//  MemeMe V.1
//
//  Created by Chi Nguyen on 1/22/17.
//  Copyright © 2017 udacity. All rights reserved.
//

import Foundation
import UIKit

class MemeTextFieldDelegate : NSObject, UITextFieldDelegate {
    // Text Field Delegate Methods
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        func textFieldDidBeginEditing(textField: UITextField) {
            textField.text = ""
        }
        
        // Figure out what the new text will be, if we return true
        var newText: NSString = textField.text! as NSString
        newText = newText.replacingCharacters(in: range, with: string) as NSString
        
        
        
        // returning true gives the text field permission to change its text
        return true;
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
}
