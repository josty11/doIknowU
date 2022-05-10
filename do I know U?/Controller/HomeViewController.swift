//
//  HomeViewController.swift
//  do I know U?
//
//  Created by Татьяна on 08.05.2022.
//

import UIKit
import CoreML
import Vision


class HomeViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var galleryButton: UIButton!
    @IBOutlet weak var takePhotoButton: UIButton!
    
    let imagePickerGallery = UIImagePickerController()
    let imagePickerCamera = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePickerGallery.delegate = self
        imagePickerCamera.delegate = self
        imagePickerCamera.sourceType = .camera
        imagePickerGallery.sourceType = .photoLibrary
        imagePickerCamera.allowsEditing = true
        imagePickerGallery.allowsEditing = true
        galleryButton.layer.cornerRadius = 15
        takePhotoButton.layer.cornerRadius = 15
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let userPickerImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            guard let ciImage = CIImage(image: userPickerImage) else {
                fatalError("Could not convert selected image into CIImage")
            }
            detect(celebImage: ciImage)
            
        }
        
        picker.dismiss(animated: true, completion: nil)
        //present Result View Controller
        performSegue(withIdentifier: K.segueName, sender: self)
        
    }
    
    func detect(celebImage: CIImage) {
        guard let model = try? VNCoreMLModel (for: CelebImageClassifier().model) else {
            fatalError("Couldn't import model ")
        }
        let request = VNCoreMLRequest(model: model) { request, error in
            guard let classification = request.results?.first as? VNClassificationObservation else {
                fatalError("Couldn't classify image")
            }
            let name = classification.identifier
            print(name)
            //self.navigationItem.title = name.capitalized
            //self.requestInfo(flowerName: name)
            //self.wikiManager.fetchWikiData(flowerName: classification?.identifier)
            
        }
        let handler = VNImageRequestHandler(ciImage: celebImage)
        
        do {
            try handler.perform([request])
        }
        catch {
            print("Error performing the request, \(error)")
        }
    }
    
    @IBAction func chooseFromGalleryPressed(_ sender: UIButton) {
        
        present(imagePickerGallery, animated: true, completion: nil)

    }
    
    @IBAction func takePhotoPressed(_ sender: UIButton) {
        
        present(imagePickerCamera, animated: true, completion: nil)
    }
    
    
//    func requestInfo(flowerName: String) {
//        let parameters : [String:String] = [
//            "format" : "json",
//            "action" : "query",
//            "prop" : "extracts|pageimages",
//            "exintro" : "",
//            "explaintext" : "",
//            "titles" : flowerName,
//            "indexpageids" : "",
//            "redirects" : "1",
//            "pithumbsize" : "500"
//        ]
//        AF.request(wikipediaURL, method: .get, parameters: parameters).responseData { (response) in
//            switch response.result {
//
//
//            case .success(let data):
//                do {
//
//                    let flowerJSON = try JSON(data: data)
//                    let pageid = flowerJSON["query"]["pageids"][0].stringValue
//
//                    let flowerDescription = flowerJSON["query"]["pages"][pageid]["extract"].stringValue
//
//                    let flowerImageURL = flowerJSON["query"]["pages"][pageid]["thumbnail"]["source"].stringValue
//                    self.label.text = flowerDescription
//                    self.imageView.sd_setImage(with: URL(string: flowerImageURL))
//
//
//                } catch {
//                    print(error)
//                }
//            case .failure:
//                print("did not get the info")
//            }
//        }
//    }
    
    
}

