//
//  UIImageView+Downloaded.swift
//  ArdaOnatOBSSCase
//
//  Created by Arda Onat on 20.05.2021.
//

import UIKit
import Alamofire

extension UIImageView {
    func downloaded(from url: URL) {
        AF.request(url, method: .get).response { response in
            switch response.result {
            case .success(let responseData):
                self.image = UIImage(data: responseData!, scale:1)
            case .failure(_):
                print("error")
            }
         }
    }
}

extension UIImage {
    static let favoriteImageName = "favorite_selected"
    static let unfavoriteImageName = "favorite_unselected"
}

extension UserDefaults {
    static let favoritedCharactersKey = "favoritedCharacters"
}
