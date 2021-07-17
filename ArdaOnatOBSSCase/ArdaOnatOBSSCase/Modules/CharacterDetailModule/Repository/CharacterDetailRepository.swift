//
//  CharacterDetailRepository.swift
//  ArdaOnatOBSSCase
//
//  Created by Arda Onat on 20.05.2021.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import Foundation

protocol CharacterDetailRepositoryProtocol {
    var output: CharacterDetailRepositoryOutputProtocol? { get set }
    
    func fetchEpisodeInformation(url: String)
    func favoriteButtonPressed(for characterId: Int)
}

protocol CharacterDetailRepositoryOutputProtocol: class {
    func onFetchEpisodeSuccess(response: EpisodeResponseModel)
    func onFetchEpisodeFailure(error: Error)
    func onAddFavoriteCompleted(isFavorited : Bool)
}

final class CharacterDetailRepository: CharacterDetailRepositoryProtocol {
    
    // MARK: Private propeties
    private let service: CharacterDetailServiceProtocol
    
    // MARK: Public properties
    weak var output: CharacterDetailRepositoryOutputProtocol?
    
    // MARK: Initializers
    init(service: CharacterDetailServiceProtocol) {
        self.service = service
    }
    
    func fetchEpisodeInformation(url: String) {
        service.fetchEpisodeInformation(with: url) { result in
            switch result {
            case .success(let response):
                self.output?.onFetchEpisodeSuccess(response: response)
            case .failure(let error):
                self.output?.onFetchEpisodeFailure(error: error)
            }
        }
    }
    
    func favoriteButtonPressed(for characterId: Int) {
        if var favoritedCharactersId = UserDefaults.standard.object(forKey: UserDefaults.favoritedCharactersKey) as? [Int] {
            if favoritedCharactersId.contains(characterId), let index = favoritedCharactersId.firstIndex(of: characterId) {
                favoritedCharactersId.remove(at:index)
                output?.onAddFavoriteCompleted(isFavorited: false)
            }
            else {
                favoritedCharactersId.append(characterId)
                output?.onAddFavoriteCompleted(isFavorited: true)
            }
            UserDefaults.standard.setValue(favoritedCharactersId, forKey: UserDefaults.favoritedCharactersKey)
        }
        else {
            UserDefaults.standard.setValue([characterId], forKey: UserDefaults.favoritedCharactersKey)
            output?.onAddFavoriteCompleted(isFavorited: true)
        }
    }
}
