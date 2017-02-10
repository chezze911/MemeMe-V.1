//
//  ViewController.swift
//  MemeMe V.1
//
//  Created by Chi Nguyen on 1/21/17.
//  Copyright © 2017 udacity. All rights reserved.
//

import Foundation
import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate,
UINavigationControllerDelegate {

    
    @IBOutlet weak var bottomBar: UIToolbar!
    @IBOutlet weak var topBar: UIToolbar!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    
    let memeDelegate = MemeTextFieldDelegate()
    // set text attributes
    let memeTextAttributes = [
    NSStrokeColorAttributeName : UIColor.black,
    NSForegroundColorAttributeName : UIColor.white,
    NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
    NSStrokeWidthAttributeName : -3.0,
    ] as [String : Any]
    
    // Do any additional setup after loading the view, typically from a nib.
    override func viewDidLoad() {
        super.viewDidLoad()
        // Set behaviors of top and bottom text fields
        self.topTextField.delegate = memeDelegate
        topTextField.defaultTextAttributes = self.memeTextAttributes
        topTextField.textAlignment = .center
        topTextField.text = "TOP"
        
        self.bottomTextField.delegate = memeDelegate
        bottomTextField.defaultTextAttributes = self.memeTextAttributes
        bottomTextField.textAlignment = .center
        bottomTextField.text = "BOTTOM"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
         //enables camera button only if camera is available
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)
        if imagePickerView.image == nil {
            shareButton.isEnabled = false
        } else {
            shareButton.isEnabled = true
        }
        
        //notifies when keyboard appears
        subscribeToKeyboardNotifications()
    }
    //opens camera roll to allow photo selection
    @IBAction func pickAnImageFromAlbum(_ sender: Any) {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = UIImagePickerControllerSourceType.photoLibrary
        present(pickerController, animated: true, completion: nil)
    }

    //enables user to take a photo
    @IBAction func pickAnImageFromCamera(_ sender: Any) {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = .camera
        present(pickerController, animated: true, completion: nil)
    }
    
    //Tells the delegate that the user picked a still image and sends photo user selected to image viewer and formats to fit
    func imagePickerController(_ sender: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imagePickerView.image = image
            dismiss(animated: true, completion: nil)
        }
        
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    //Keyboard
    //moves frame up when keyboard shows only on bottom text field
    func keyboardWillShow(_ notification:Notification) {
        if bottomTextField.isFirstResponder && view.frame.origin.y == 0.0{ // check if text field is currently selected
            view.frame.origin.y = -getKeyboardHeight(notification)
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        view.frame.origin.y = 0 // (0,0) is the original view location
    }
    //gets keyboard height to move up frame
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    // moves frame back down after moving up keyboard
    
    //notifies when keyboard raises
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
    }
    //unsubscribes
    override func viewWillDisappear(_ animated: Bool) {
        //notifies when keyboard disappears
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    func save() {
        // create the meme
        let memedImage = generateMemedImage()
        
        let meme = Meme(topTextField: topTextField.text! as NSString, bottomTextField: bottomTextField.text! as NSString,
                        image: imagePickerView.image!, memedImage: memedImage)
        
        // Add it to the memes array in the Application Delegate
        (UIApplication.shared.delegate as!
            AppDelegate).memes.append(meme)
    }
    func generateMemedImage() -> UIImage {
        
        // Hide toolbar and navbar
        topBar.isHidden = true
        bottomBar.isHidden = true
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame,
                                     afterScreenUpdates: true)
        let memedImage : UIImage =
            UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        // Show toolbar and navbar
        topBar.isHidden = false
        bottomBar.isHidden = false
        
        return memedImage
    }

    //share meme
    @IBAction func share(_ sender: Any) {
        let memedImage = generateMemedImage()
        let activityController = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        
        activityController.completionWithItemsHandler = { activity, completed, returned, error in
            //Allows meme to be saved if activity is completed
            if completed{
                self.save()
                self.dismiss(animated: true, completion: nil)
            }
        self.present(activityController, animated: true, completion: nil)
        }
    }
    // clear the text and image
    @IBAction func cancelAction(_ sender: Any) {
        imagePickerView.image = nil
        topTextField.text?.removeAll()
        bottomTextField.text?.removeAll()
        viewDidLoad()
    }
}

