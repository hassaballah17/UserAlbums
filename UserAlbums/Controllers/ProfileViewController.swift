//
//  ViewController.swift
//  UserAlbums
//
//  Created by Ahmed Hassaballah on 15/09/2025.
//

import UIKit
import Combine

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    
    private var viewModel = ProfileViewModel()
    private var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        
        bindViewModel()
        viewModel.fetchRandomUser()
    }
    
    private func bindViewModel() {
        // Update user info
        viewModel.$user
            .receive(on: DispatchQueue.main)
            .sink { [weak self] user in
                guard let user = user else { return }
                self?.nameLabel.text = "Hi, \(user.name)!"
                self?.addressLabel.text = "\(user.address.street), \(user.address.city)"
            }
            .store(in: &cancellables)
        
        // Update table when albums change
        viewModel.$albums
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.tableView.reloadData()
            }
            .store(in: &cancellables)
    }
}

extension ProfileViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.albums.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "AlbumCell", for: indexPath) as? AlbumCell else {
            return UITableViewCell()
        }
        let album = viewModel.albums[indexPath.row]
        cell.configure(with: album.title)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            let album = viewModel.albums[indexPath.row]
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let photosVC = storyboard.instantiateViewController(withIdentifier: "PhotosViewController") as! PhotosViewController
            
            photosVC.user = viewModel.user
            photosVC.album = album
            
            
            navigationController?.pushViewController(photosVC, animated: true)
        }
}


