//
//  CharacterDetailInteractor.swift
//  ArdaOnatOBSSCase
//
//  Created by Arda Onat on 20.05.2021.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import Foundation

protocol CharacterDetailInteractorProtocol {
    var repository: CharacterDetailRepositoryProtocol { get }
    var output: CharacterDetailInteractorOutputProtocol? { get set }
    
    func fetchEpisodeInformation(url: String)
    func favoriteButtonPressed(for characterId: Int)
}

protocol CharacterDetailInteractorOutputProtocol: class {
    func onFetchEpisodeSuccess(response: EpisodeResponseModel)
    func onFetchEpisodeFailure(error: Error)
    func onAddFavoriteCompleted(isFavorited: Bool)
}

final class CharacterDetailInteractor: CharacterDetailInteractorProtocol {

    // MARK: Public properties
    let repository: CharacterDetailRepositoryProtocol
    weak var output: CharacterDetailInteractorOutputProtocol?
    
    // MARK: Initializers
    init(repository: CharacterDetailRepositoryProtocol) {
        self.repository = repository
    }
    
    func fetchEpisodeInformation(url: String) {
        repository.fetchEpisodeInformation(url: url)
    }
    
    func favoriteButtonPressed(for characterId: Int) {
        repository.favoriteButtonPressed(for: characterId)
    }
}

extension CharacterDetailInteractor: CharacterDetailRepositoryOutputProtocol {
    func onFetchEpisodeSuccess(response: EpisodeResponseModel) {
        output?.onFetchEpisodeSuccess(response: response)
    }
    
    func onFetchEpisodeFailure(error: Error) {
        output?.onFetchEpisodeFailure(error: error)
    }
    
    func onAddFavoriteCompleted(isFavorited: Bool) {
        output?.onAddFavoriteCompleted(isFavorited: isFavorited)
    }
}
