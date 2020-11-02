//
//  CameraViewController.swift
//  Instagram
//
//  Created by Ruchika Gupta on 10/23/20.
//

import UIKit
import AlamofireImage
import Parse

//Callback with function that gives the image

class CameraViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    
    
    @IBOutlet weak var commentField: UITextField!
    
    @IBAction func onSubmitButton(_ sender: Any) {
        
       print("called")
        let post =  PFObject(className: "post")
        
        post["caption"] = commentField.text
        
        post["author"] = PFUser.current()!
        
        let imageData = imageView.image?.pngData()
        //! for unwrapping
        let file = PFFileObject(name: "image.png", data: imageData!)
        
        //Url to this file hwerre the image is stored
        post["image"] = file
        
       
        post.saveInBackground {  (success, error) in
            if (success){
                self.dismiss(animated: true, completion: nil)
                print("saved")
            }
            else{
                print("Error")
            }
            
        }
    }
    
    
    @IBAction func onCameraButton(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.delegate = self // Call me back after take photo
        picker.allowsEditing = true
        
        //Checks if the camera on your phone  is available
        if UIImagePickerController.isSourceTypeAvailable(   .camera){
            //opens up camera by default
            picker.sourceType = .camera
        }
        else{
            //Simulator
            picker.sourceType = .photoLibrary
        }
        
        
        //Shows the photo album when you clcik on camera button
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        //Image comes in dic called info
        let image = info[.editedImage] as! UIImage
        //Resize the image
        let size = CGSize(width: 300, height: 300)
        let scaledImage = image.af_imageAspectScaled(toFill: size)
        //let scaledImage = image.af_imageScaled(to:size)
        
        imageView.image = scaledImage
        
        //Dismiss camerra view
        
        dismiss(animated: true, completion: nil)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

