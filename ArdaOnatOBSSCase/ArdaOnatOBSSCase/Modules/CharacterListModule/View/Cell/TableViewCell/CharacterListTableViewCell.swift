//
//  CharacterListTableViewCell.swift
//  ArdaOnatOBSSCase
//
//  Created by Arda Onat on 20.05.2021.
//

import UIKit

class CharacterListTableViewCell: UITableViewCell {

    static let ReuseIdentifier: String = "CharacterListTableViewCell"
    
    private struct Constants {
        static let favoriteImageName: String = "favorite_selected"
        static let unfavoriteImageName: String = "favorite_unselected"
    }
    
    // MARK: IBOutlets
    @IBOutlet private weak var characterImageView: UIImageView!
    @IBOutlet private weak var favoriteImageView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var statusLabel: UILabel!
    @IBOutlet private weak var speciesLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(characterImageURL: URL, name: String, status: CharacterStatus, species: String, isFavorited: Bool) {
        characterImageView.downloaded(from: characterImageURL)
        nameLabel.text = name
        statusLabel.text = status.rawValue
        speciesLabel.text = species
        favoriteImageView.image = isFavorited ? UIImage(named: Constants.favoriteImageName) : UIImage(named: Constants.unfavoriteImageName)
    }
}
