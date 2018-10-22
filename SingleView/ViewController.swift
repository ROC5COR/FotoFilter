//
//  ViewController.swift
//  SingleView
//
//  Created by Romain LE DONGE on 19/10/2018.
//  Copyright © 2018 Romain LE DONGE. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var imgView: UIImageView!
    let context = CIContext()
    
    var originalImage = UIImage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            originalImage = pickedImage
            
            imgView.contentMode = .scaleAspectFit
            imgView.image = originalImage
        }

        picker.dismiss(animated: true, completion: nil)
    }
    
    func sepiaFilter(_ input: CIImage, intensity: Double) -> CIImage? {
        let sepiaFilter = CIFilter(name:"CISepiaTone")
        sepiaFilter?.setValue(input, forKey: kCIInputImageKey)
        sepiaFilter?.setValue(intensity, forKey: kCIInputIntensityKey)
        return sepiaFilter?.outputImage
    }
    
    func bloomFilter(_ input:CIImage, intensity: Double, radius: Double) -> CIImage? {
        let bloomFilter = CIFilter(name:"CIBloom")
        bloomFilter?.setValue(input, forKey: kCIInputImageKey)
        bloomFilter?.setValue(intensity, forKey: kCIInputIntensityKey)
        bloomFilter?.setValue(radius, forKey: kCIInputRadiusKey)
        return bloomFilter?.outputImage
    }
    
    func applyFilter(filterName: String, value: Double) {
        if let ciImg = CIImage(image: originalImage) {
            if filterName == "sepia" {
                if let filteredImg = sepiaFilter(ciImg, intensity: value) {
                    imgView.image = UIImage(ciImage: filteredImg)
                } else {
                    print("Error: Can't apply filtered")
                }
            } else if filterName == "blur" {
                if let filteredImg = bloomFilter(ciImg, intensity: value, radius: 20) {
                    imgView.image = UIImage(ciImage: filteredImg)
                } else {
                    print("Error: Can't apply filtered")
                }
            } else {
                print("Not a known filter")
            }
        }
    }
    
    @IBAction func sliderValueChanged(_ sender: UISlider) {
        let value = sender.value
        applyFilter(filterName: "sepia", value: Double(value))
    }
    
    @IBAction func takePicture(_ sender: Any) {
        print("Take picture pressed")
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera){
            print("Can take picture")
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        } else {
            print("Can't take picture ! :(")
        }
    }
}

