//
//  CharacterListCollectionViewCell.swift
//  ArdaOnatOBSSCase
//
//  Created by Arda Onat on 20.05.2021.
//

import UIKit

class CharacterListCollectionViewCell: UICollectionViewCell {

    static let ReuseIdentifier: String = "CharacterListCollectionViewCell"
    
    // MARK: IBOutlets
    @IBOutlet private weak var characterImageView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var statusLabel: UILabel!
    @IBOutlet private weak var speciesLabel: UILabel!
    @IBOutlet private weak var favoriteImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func configure(characterImageURL: URL, name: String, status: CharacterStatus, species: String, isFavorited: Bool) {
        characterImageView.downloaded(from: characterImageURL)
        nameLabel.text = name
        statusLabel.text = status.rawValue
        speciesLabel.text = species
        favoriteImageView.image = isFavorited ? UIImage(named: UIImage.favoriteImageName) : UIImage(named: UIImage.unfavoriteImageName)
    }
}
