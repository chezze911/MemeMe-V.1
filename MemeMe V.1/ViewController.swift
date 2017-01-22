//
//  ViewController.swift
//  MemeMe V.1
//
//  Created by Chi Nguyen on 1/21/17.
//  Copyright © 2017 udacity. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate,
UINavigationControllerDelegate {
    

    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var imagePickerView: UIImageView!
    
    let memeDelegate = MemeTextFieldDelegate()
    
    // set text attributes
    let memeTextAttributes = [
    NSStrokeColorAttributeName : UIColor.black,
    NSForegroundColorAttributeName: UIColor.white,
    NSFontAttributeName: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
    NSStrokeWidthAttributeName : -4.0
    ] as [String : Any]
    
    // Do any additional setup after loading the view, typically from a nib.
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
         //enables camera button only if camera is available
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)
        
        //notifies when keyboard appears and disappears
        self.subscribeToKeyboardNotifications()
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
    //Tells the delegate that the user picked a still image
    //and sends photo user selected to image viewer and formats to aspect fit
    func imagePickerController(_: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imagePickerView.image = image
            dismiss(animated: true, completion: nil)
        }
    }
    //Tells the delegate that the user cancelled the pick operation.
    func imagePickerControllerDidCancel(_: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
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
    //notifies when keyboard raises
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
    }
    //turns notification off
    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
    }
    //unsubscribe
    override func viewWillDisappear(_ animated: Bool) {
        //notifies when keyboard disappears
        super.viewWillDisappear(animated)
        self.unsubscribeFromKeyboardNotifications()
    }
    
}

