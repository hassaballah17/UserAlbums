//
//  PhotoDetailsViewController.swift
//  UserAlbums
//
//  Created by Ahmed Hassaballah on 17/09/2025.
//

import UIKit

class PhotoDetailsViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageView: UIImageView!
    
    var image: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Photo Details"
        imageView.image = image
        imageView.contentMode = .scaleAspectFit
        
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 4.0
        scrollView.delegate = self
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .action,
            target: self,
            action: #selector(shareImage)
        )
        
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTap(_:)))
        doubleTap.numberOfTapsRequired = 2
        scrollView.addGestureRecognizer(doubleTap)
    }
 
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
     @objc private func handleDoubleTap(_ recognizer: UITapGestureRecognizer) {
        if scrollView.zoomScale == 1 {
             
            scrollView.setZoomScale(2.0, animated: true)
        } else {
            
            scrollView.setZoomScale(1.0, animated: true)
        }
    }
    
     @objc private func shareImage() {
        guard let image = imageView.image else { return }
        let activityVC = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        present(activityVC, animated: true)
    }
}
