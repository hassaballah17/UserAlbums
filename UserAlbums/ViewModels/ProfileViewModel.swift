//
//  ProfileViewModel.swift
//  UserAlbums
//
//  Created by Ahmed Hassaballah on 15/09/2025.
//

import Foundation
import Moya
import Combine

class ProfileViewModel {
    private let provider = MoyaProvider<APIService>()
    private var cancellables = Set<AnyCancellable>()
    
    @Published var user: User?
    @Published var albums: [Album] = []
    @Published var errorMessage: String?
    
    // public API
    func fetchRandomUser() {
        // Use the generic helper: requestPublisher(Type, target)
        provider.requestPublisher([User].self, .users)
            .receive(on: DispatchQueue.main) // update published properties on main
            .sink { [weak self] completion in
                if case let .failure(error) = completion {
                    self?.errorMessage = error.localizedDescription
                }
            } receiveValue: { [weak self] users in
                guard let self = self else { return }
                guard let randomUser = users.randomElement() else { return }
                self.user = randomUser
                self.fetchAlbums(for: randomUser.id)
            }
            .store(in: &cancellables)
    }
    
    // private helper
    private func fetchAlbums(for userId: Int) {
        provider.requestPublisher([Album].self, .albums(userId: userId))
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                if case let .failure(error) = completion {
                    self?.errorMessage = error.localizedDescription
                }
            } receiveValue: { [weak self] albums in
                self?.albums = albums
            }
            .store(in: &cancellables)
    }
}
