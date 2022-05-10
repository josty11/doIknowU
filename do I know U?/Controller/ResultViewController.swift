//
//  ResultViewController.swift
//  do I know U?
//
//  Created by Татьяна on 10.05.2022.
//

import UIKit

class ResultViewController: UIViewController {

    @IBOutlet weak var extractLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var navigationTitle: UINavigationItem!
    var celebName: String? = ""
    var celebExtract: String? = ""
    var celebImage: CIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationTitle.title = celebName
        self.extractLabel.text = celebExtract
        if let image = celebImage {
            self.imageView.image = UIImage(ciImage: image)
        }
        
    }

}
