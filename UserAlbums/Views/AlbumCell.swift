//
//  AlbumCell.swift
//  UserAlbums
//
//  Created by Ahmed Hassaballah on 15/09/2025.
//

import Foundation
import UIKit

class AlbumCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    
    func configure(with title: String) {
            titleLabel.text = title
        }
    
}
