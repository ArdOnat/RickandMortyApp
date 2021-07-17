//
//  CharacterDetailPresenter.swift
//  ArdaOnatOBSSCase
//
//  Created by Arda Onat on 20.05.2021.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol CharacterDetailPresenterProtocol: class {
    var view: CharacterDetailViewProtocol? { get set }
    var interactor: CharacterDetailInteractorProtocol { get }
    var viewModel: CharacterDetailViewModel? { get set }
    
    func fetchLastEpisodeInformation()
    func favoriteButtonPressed()
}
    
final class CharacterDetailPresenter: CharacterDetailPresenterProtocol {

    // MARK: Public properties
    weak var view: CharacterDetailViewProtocol?
    let interactor: CharacterDetailInteractorProtocol
    var viewModel: CharacterDetailViewModel?

    // MARK: Initializer
    init(interactor: CharacterDetailInteractorProtocol,  characterInformation: CharacterInformation) {
        self.interactor = interactor
        self.viewModel = CharacterDetailViewModel(characterInformation: characterInformation)
    }
    
    func fetchLastEpisodeInformation() {
        view?.showLoading(shouldShow: true)
        guard let episodeURL = viewModel?.lastEpisodeURL else {
            view?.showLoading(shouldShow: false)
            return
        }
        interactor.fetchEpisodeInformation(url: episodeURL)
    }
    
    func favoriteButtonPressed() {
        guard let id = viewModel?.characterInformation?.id else { return }
        interactor.favoriteButtonPressed(for: id)
    }
}

extension CharacterDetailPresenter: CharacterDetailInteractorOutputProtocol {
    func onFetchEpisodeSuccess(response: EpisodeResponseModel) {
        view?.refreshUI(episodeName: response.name, airDate: response.air_date)
        view?.showLoading(shouldShow: false)
    }
    
    func onFetchEpisodeFailure(error: Error) {
        
    }
    
    func onAddFavoriteCompleted(isFavorited: Bool) {
        view?.updateFavoriteButton(isFavorited: isFavorited)
    }
}
