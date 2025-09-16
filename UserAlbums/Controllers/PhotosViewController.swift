//
//  PhotosViewController.swift
//  UserAlbums
//
//  Created by Ahmed Hassaballah on 15/09/2025.
//

import UIKit
import Combine

class PhotosViewController: UIViewController {
    var user: User!
    var album: Album!
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var albumLabel: UILabel!
    
    private var viewModel = PhotosViewModel()
    private var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameLabel.text = "Hi, \(user.name)!"
        albumLabel.text = album.title
        setupCollectionView()
        
        viewModel.fetchPhotos(for: album.id)
        bindViewModel()
    }
    
    private func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        
        
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            let padding: CGFloat = 8
            let itemsPerRow: CGFloat = 3
            let totalPadding = padding * (itemsPerRow + 1)
            let itemWidth = (view.frame.width - totalPadding) / itemsPerRow
            layout.itemSize = CGSize(width: itemWidth, height: itemWidth)
            layout.minimumInteritemSpacing = padding
            layout.minimumLineSpacing = padding
            collectionView.contentInset = UIEdgeInsets(
                top: padding,
                left: padding,
                bottom: padding,
                right: padding
            )
        }
    }
    
    private func bindViewModel() {

        viewModel.$photos
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.collectionView.reloadData()
            }
            .store(in: &cancellables)
        
        // Handle errors
        viewModel.$errorMessage
            .compactMap { $0 }
            .sink { error in
                print("Error fetching photos: \(error)")
            }
            .store(in: &cancellables)
    }
}

extension PhotosViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.photos.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: PhotoCell.reuseIdentifier,
            for: indexPath
        ) as? PhotoCell else {
            return UICollectionViewCell()
        }
        
        let photo = viewModel.photos[indexPath.item]
        cell.configure(with: photo)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let photo = viewModel.photos[indexPath.item]
        print("Tapped photo: \(photo.title)")
        // Later: navigate to a fullscreen photo viewer
    }
}
