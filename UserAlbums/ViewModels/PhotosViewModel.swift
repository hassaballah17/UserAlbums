//
//  PhotosViewModel.swift
//  UserAlbums
//
//  Created by Ahmed Hassaballah on 15/09/2025.
//

import Foundation
import Moya
import Combine

class PhotosViewModel {
    private let provider = MoyaProvider<APIService>()
    private var cancellables = Set<AnyCancellable>()
    
    @Published var photos: [Photo] = []
    @Published var errorMessage: String?
    
    func fetchPhotos(for albumId: Int) {
        provider.requestPublisher([Photo].self, .photos(albumId: albumId))
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                if case let .failure(error) = completion {
                    self?.errorMessage = error.localizedDescription
                }
            } receiveValue: { [weak self] photos in
                self?.photos = photos
            }
            .store(in: &cancellables)
        print("Fetched")
    }
}

