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

    @IBOutlet weak var imagePickerView: UIImageView!
    
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    
    override func viewWillAppear(_ animated: Bool) {
        ViewController.delegate = self
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }


    @IBAction func pickAnImage(_ sender:Any) {
        
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = UIImagePickerControllerSourceType.photoLibrary
        self.present(pickerController, animated: true, completion: nil)
    }
    func imagePickerController(_: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.imagePickerView.image = image
            self.dismiss(animated: true, completion: nil)
            //Tells the delegate that the user picked a still image
        }
    }
    func imagePickerControllerDidCancel(_: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
        //Tells the delegate that the user cancelled the pick operation.
    }
    @IBAction func pickAnImageFromCamera(_ sender: Any) {
        
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = .camera
        present(pickerController, animated: true, completion: nil)
    }
}

