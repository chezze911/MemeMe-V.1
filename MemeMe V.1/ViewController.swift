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
    @IBOutlet weak var toolbar: UIToolbar!

    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    
    let memeDelegate = MemeTextFieldDelegate()
    
    @IBOutlet weak var activityBar: UIBarButtonItem!
    // set text attributes
    let memeTextAttributes = [
    NSStrokeColorAttributeName : UIColor.black,
    NSForegroundColorAttributeName : UIColor.white,
    NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
    NSStrokeWidthAttributeName : -4.0,
    ] as [String : Any]
    
    // Do any additional setup after loading the view, typically from a nib.
    override func viewDidLoad() {
        super.viewDidLoad()
        // Set behaviors of top and bottom text fields
        self.topTextField.delegate = memeDelegate
        self.bottomTextField.delegate = memeDelegate
        topTextField.defaultTextAttributes = self.memeTextAttributes
        bottomTextField.defaultTextAttributes = self.memeTextAttributes
        topTextField.text = "TOP"
        bottomTextField.text = "BOTTOM"
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
         //enables camera button only if camera is available
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)
        
        //notifies when keyboard appears
        subscribeToKeyboardNotifications()
    }
    //opens camera roll to allow photo selection
    @IBAction func pickAnImage(_ sender:Any) {
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
        }
        
        dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    //Keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    //moves frame up when keyboard shows
    func keyboardWillShow(_ notification:Notification) {
        self.view.frame.origin.y = 0 - getKeyboardHeight(notification)
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
    }
    //turns notification off
    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
    }
    //unsubscribes
    override func viewWillDisappear(_ animated: Bool) {
        //notifies when keyboard disappears
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    func generateMemedImage() -> UIImage {
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return memedImage
    }
    
    // Use action button to share meme
    @IBAction func share(sender: AnyObject) {
        let memedImage = generateMemedImage()
        let activityViewController = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        activityViewController.completionWithItemsHandler = { (s: String?, ok: Bool, items: [AnyObject]?, err: NSError?) -> Void in
            if ok {
                self.save()
                NSLog("Successfully saved meme image.")
            } else if err != nil {
                NSLog("Error: \(err)")
            } else {
                NSLog("User clicked cancel")
            }
        }
        
        present(activityViewController, animated: true, completion: nil)
    }
    
    // create the meme
    func save() {
        let meme = Meme(topTextField: topTextField.text! as NSString, bottomTextField: bottomTextField.text! as NSString, image:
            imagePickerView.image!, memedImage: generateMemedImage())
        (UIApplication.sharedApplication.delegate as! AppDelegate).memes.append(meme)
    }
    
    // clear the text and image when cancel is pressed
    @IBAction func cancelAction(sender: AnyObject) {
        imagePickerView.image = nil
        topTextField.text?.removeAll()
        bottomTextField.text?.removeAll()
        viewDidLoad()
    }
    
}

