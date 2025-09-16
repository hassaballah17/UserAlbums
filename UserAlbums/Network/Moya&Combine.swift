//
//  Moya&Combine.swift
//  UserAlbums
//
//  Created by Ahmed Hassaballah on 15/09/2025.
//

import Foundation
import Combine
import Moya

// Make this extension available for providers typed to a TargetType (e.g. MoyaProvider<APIService>)
extension MoyaProvider where Target: TargetType {
    /// Generic helper: decode the response into `T` and return a Combine publisher.
    func requestPublisher<T: Decodable>(
        _ type: T.Type,
        _ target: Target,
        callbackQueue: DispatchQueue? = nil,
        decoder: JSONDecoder = JSONDecoder()
    ) -> AnyPublisher<T, Error> {
        Future { promise in
            self.request(target, callbackQueue: callbackQueue) { result in
                switch result {
                case .success(let response):
                    do {
                        let decoded = try decoder.decode(T.self, from: response.data)
                        promise(.success(decoded))
                    } catch {
                        promise(.failure(error))
                    }
                case .failure(let error):
                    promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }
}
