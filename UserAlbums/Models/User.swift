//
//  User.swift
//  UserAlbums
//
//  Created by Ahmed Hassaballah on 15/09/2025.
//

import Foundation

struct User: Codable{
    let id: Int
    let name: String
    let address: Address
}

struct Address: Codable{
    let street: String
    let suite: String
    let city: String
    let zipcode: String
}

