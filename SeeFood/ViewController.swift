//
//  ViewController.swift
//  SeeFood
//
//  Created by Amerigo Mancino on 02/08/2019.
//  Copyright © 2019 Amerigo Mancino. All rights reserved.
//

import UIKit
import CoreML
import Vision

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        // the camera is the main source of the image picker
        imagePicker.sourceType = .camera
        // the editing should be allowed so that the user could crop the image and the ML algorithm could work on
        // less area and a more specific target to figure out what that item is; for semplicity we're skipping
        // this part
        imagePicker.allowsEditing = false
    }
    
    // tells the delegate that the user has picked an image
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        // the info parameters contains the image that the user picked
        if let userPickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imageView.image = userPickedImage
        }
        
        // dismiss the imagePicker
        imagePicker.dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func cameraTapped(_ sender: UIBarButtonItem) {
        // let the image picker to appear
        present(imagePicker, animated: true, completion: nil)
    }


}

