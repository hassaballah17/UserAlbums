//
//  PhotoDetailsViewController.swift
//  UserAlbums
//
//  Created by Ahmed Hassaballah on 17/09/2025.
//

import UIKit

class PhotoDetailsViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    
    var image: UIImage?
        
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = image
    }
    
}

