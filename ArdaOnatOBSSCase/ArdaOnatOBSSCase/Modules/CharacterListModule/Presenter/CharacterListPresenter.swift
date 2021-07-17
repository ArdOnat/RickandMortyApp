//
//  CharacterListPresenter.swift
//  ArdaOnatOBSSCase
//
//  Created by Arda Onat on 20.05.2021.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol CharacterListPresenterProtocol: class {
    var view: CharacterListViewProtocol? { get set }
    var interactor: CharacterListInteractorProtocol { get }
    var wireframe: CharacterListWireframeProtocol { get }
    var viewModel: CharacterListViewModel? { get set }
    
    func fetchCharacters(searchTerm: String?, status: CharacterStatus?, shouldResetData: Bool)
    func presentCharacterDetail(with navigationController: UINavigationController, characterInformation: CharacterInformation)
}
    
final class CharacterListPresenter: CharacterListPresenterProtocol {

    // MARK: Public properties
    weak var view: CharacterListViewProtocol?
    let interactor: CharacterListInteractorProtocol
    let wireframe: CharacterListWireframeProtocol
    var viewModel: CharacterListViewModel?

    // MARK: Private properties
    private var shouldResetData: Bool? {
        didSet {
            guard let shouldResetData = shouldResetData, shouldResetData else { return }
            viewModel?.clearData()
        }
    }
    private var currentPage: Int = 0
    private var isFetchInProgress: Bool? {
        didSet {
            guard let view = view, let isFetchInProgress = isFetchInProgress else { return }
            view.showLoading(shouldShow: isFetchInProgress)
        }
    }
    
    // MARK: Initializer
    init(interactor: CharacterListInteractorProtocol,
         wireframe: CharacterListWireframeProtocol) {
        self.interactor = interactor
        self.wireframe = wireframe
        self.viewModel = CharacterListViewModel()
    }
    
    // MARK: Life Cycle
    func fetchCharacters(searchTerm: String? = nil, status: CharacterStatus? = nil, shouldResetData: Bool) {
        self.shouldResetData = shouldResetData
        
        if shouldResetData {
            currentPage = 0
        }
        
        guard !(isFetchInProgress ?? false) else { return }
        isFetchInProgress = true
        interactor.fetchCharacters(with: currentPage, searchTerm: searchTerm, status: status)
    }
    
    func presentCharacterDetail(with navigationController: UINavigationController, characterInformation: CharacterInformation) {
        wireframe.presentCharacterDetail(with: navigationController, characterInformation: characterInformation, closedDelegate: self)
    }
}

extension CharacterListPresenter: CharacterListInteractorOutputProtocol {
    func onFetchCharactersSuccess(response: CharacterListResponseModel) {
        currentPage += 1
        isFetchInProgress = false
        
        viewModel?.addCharacters(characters: response.results)
        viewModel?.lastPageInfo = response.info
        view?.refreshUIWithSuccess()
    }
    
    func onFetchCharactersFailure(error: Error) {
        isFetchInProgress = false
        viewModel?.clearData()
        view?.showError()
    }
}

extension CharacterListPresenter: CharacterDetailClosedDelegate {
    func onCharacterDetailClose() {
        view?.refreshSelectedCell()
    }
}
