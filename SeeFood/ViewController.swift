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
            
            // convert the image into a Core Image (necessary to use CoreML)
            guard let ciimage = CIImage(image: userPickedImage) else {
                fatalError("Coult not convert to CIImage.")
            }
            
            // detect what the image contains using the Incepction V3 model
            detect(image: ciimage)
        }
        
        // dismiss the imagePicker
        imagePicker.dismiss(animated: true, completion: nil)
        
    }
    
    
    func detect(image: CIImage) {
        
        // define the container for the mlmodel (whatever it is)
        // the parameter is the name of the auto generated class got from the mlmodel import
        guard let model = try? VNCoreMLModel(for: Inceptionv3().model) else {
            fatalError("Loading CoreML model failed.")
        }
        
        // ask the model to classify whatever data that we passed
        let request = VNCoreMLRequest(model: model) { (request, error) in
            // if the request succedeed...
            guard let results = request.results as? [VNClassificationObservation] else {
                fatalError("Model failed to process the image")
            }
            
            // print(results)
            
            // tap into the first result of the list
            if let firstResult = results.first {
                // check if the first result contains the keyword "hotdog"
                if firstResult.identifier.contains("hotdog") {
                    self.navigationItem.title = "Hotdog!"
                    self.navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1)
                } else {
                    self.navigationItem.title = "Not Hotdog!"
                    self.navigationController?.navigationBar.barTintColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
                }
            }
            
        }
        
        // data that we passed to the model
        let handler = VNImageRequestHandler(ciImage: image)
        
        do {
            // perform the request by using the handler
            try handler.perform([request])
        } catch {
            print(error)
        }
        
        
    }
    
    
    @IBAction func cameraTapped(_ sender: UIBarButtonItem) {
        // let the image picker to appear
        present(imagePicker, animated: true, completion: nil)
    }


}

