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
        // Set text boxes behaviors
        self.bottomTextField.delegate = memeDelegate
        self.topTextField.delegate = memeDelegate
        bottomTextField.defaultTextAttributes = memeTextAttributes
        topTextField.defaultTextAttributes = memeTextAttributes
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
         //enables camera button only if camera is available
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)
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
    

}

