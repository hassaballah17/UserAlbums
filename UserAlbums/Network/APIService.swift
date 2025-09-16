//
//  APIService.swift
//  UserAlbums
//
//  Created by Ahmed Hassaballah on 15/09/2025.
//

import Moya
import Foundation

enum APIService {
    case users
    case albums(userId: Int)
    case photos(albumId: Int)
}

extension APIService: TargetType {
    var baseURL: URL {
        return URL(string: "https://jsonplaceholder.typicode.com")!
    }
    
    var path: String {
        switch self {
        case .users: return "/users"
        case .albums: return "/albums"
        case .photos: return "/photos"
        }
    }
    
    var method: Moya.Method {
        return .get
    }
    
    var task: Task {
        switch self {
        case .users:
            return .requestPlain
        case .albums(let userId):
            return .requestParameters(parameters: ["userId": userId],
                                      encoding: URLEncoding.queryString)
        case .photos(let albumId):
            return .requestParameters(parameters: ["albumId": albumId],
                                      encoding: URLEncoding.queryString)
        }
    }
    
    var headers: [String : String]? {
        return ["Content-Type": "application/json"]
    }
    
    var sampleData: Data {
        return Data()
    }
    
}
