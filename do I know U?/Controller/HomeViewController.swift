//
//  HomeViewController.swift
//  do I know U?
//
//  Created by Татьяна on 08.05.2022.
//

import UIKit
import CoreML
import Vision


class HomeViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, WikiManagerDelegate {
    
    

    @IBOutlet weak var galleryButton: UIButton!
    @IBOutlet weak var takePhotoButton: UIButton!
    
    let imagePickerGallery = UIImagePickerController()
    let imagePickerCamera = UIImagePickerController()
    var wikiManager = WikiManager()
    var celebTitle: String?
    var celebExtract: String?
    var celebImage: CIImage?
    
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
        
        wikiManager.delegate = self
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
        
        
        
        //performSegue(withIdentifier: K.segueName, sender: self)
        
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
            self.wikiManager.fetchWikiData(celebName: name)
            self.celebImage = celebImage
            
            
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
    func didFailWithError(error: Error) {
        print("An error occured, \(error)")
    }
    func didUpdateWikiData(_ wikiManager: WikiManager, wiki: Results) {
        
        print("wikiData updated: \(wiki.extract)")
        DispatchQueue.main.async {
            self.celebTitle = wiki.title
            self.celebExtract = wiki.extract
            
            let svc = self.storyboard!.instantiateViewController(withIdentifier: "ResultViewController") as! ResultViewController
            svc.celebName = self.celebTitle
            svc.celebExtract = self.celebExtract
            svc.celebImage = self.celebImage
            self.present(svc, animated: true, completion: nil)
        }
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.segueName {
            let destinationVC = segue.destination as! ResultViewController
            
            if let name = self.celebTitle, let extract = self.celebExtract {
                destinationVC.celebName = name
                destinationVC.celebExtract = extract
            }
        }
    }
    
}

