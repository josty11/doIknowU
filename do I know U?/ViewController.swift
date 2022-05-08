//
//  ViewController.swift
//  do I know U?
//
//  Created by Татьяна on 08.05.2022.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var galleryButton: UIButton!
    @IBOutlet weak var takePhotoButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        galleryButton.layer.cornerRadius = 15
        takePhotoButton.layer.cornerRadius = 15
    }

    @IBAction func chooseFromGalleryPressed(_ sender: UIButton) {
        print("gallery")
    }
    
    @IBAction func takePhotoPressed(_ sender: UIButton) {
        print("take photo")
    }
}

