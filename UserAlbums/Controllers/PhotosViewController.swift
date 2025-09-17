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
    
    private var searchController: UISearchController!
    private var filteredPhotos: [Photo] = []
    private var isSearching = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameLabel.text = "Hi, \(user.name)!"
        albumLabel.text = album.title
        setupSearchController()
        setupCollectionView()
        
        viewModel.fetchPhotos(for: album.id)
        bindViewModel()
    }
    
    private func setupSearchController() {
            searchController = UISearchController(searchResultsController: nil)
            searchController.searchBar.placeholder = "Search photos"
            searchController.obscuresBackgroundDuringPresentation = false
            searchController.searchBar.delegate = self
            navigationItem.searchController = searchController
            definesPresentationContext = true
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
        let photo = isSearching ? filteredPhotos[indexPath.item] : viewModel.photos[indexPath.item]
        
        if let cell = collectionView.cellForItem(at: indexPath) as? PhotoCell,
           let currentImage = cell.imageView.image {
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let detailsVC = storyboard.instantiateViewController(withIdentifier: "PhotoDetailsViewController") as? PhotoDetailsViewController {
                detailsVC.image = currentImage   // pass UIImage, not URL
                navigationController?.pushViewController(detailsVC, animated: true)
            }
        }
    }
    

}

extension PhotosViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
            let query = searchBar.text ?? ""
            if query.isEmpty {
                isSearching = false
                filteredPhotos = []
            } else {
                isSearching = true
                filteredPhotos = viewModel.photos.filter { $0.title.lowercased().contains(query.lowercased()) }
            }
            collectionView.reloadData()
            searchController.isActive = false  // close keyboard
    }
}

