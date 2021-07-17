//
//  FakeCharacterListPresenter.swift
//  ArdaOnatOBSSCase
//
//  Created by Arda Onat on 23.05.2021.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
@testable import ArdaOnatOBSSCase

class FakeCharacterListPresenter: CharacterListPresenterProtocol, CharacterListInteractorOutputProtocol {

    // MARK: - Properties
    var viewModel: CharacterListViewModel?
    weak var view: CharacterListViewProtocol?
    var interactor: CharacterListInteractorProtocol
    var wireframe: CharacterListWireframeProtocol
    
    // MARK: - Test Properties
    var didFetchCharactersCalled: Bool = false
    var didPresentCharacterDetailCalled: Bool = false
    var didOnFetchCharactersSuccessCalled: Bool = false
    var didOnFetchCharactersFailureCalled: Bool = false
    
    // MARK: - Initializers
    required init(interactor: CharacterListInteractorProtocol, wireframe: CharacterListWireframeProtocol, viewModel: CharacterListViewModel) {
        self.interactor = interactor
        self.wireframe = wireframe
        self.viewModel = viewModel
    }
    
    init() {
        self.interactor = FakeCharacterListInteractor()
        self.wireframe = FakeCharacterListWireframe()
        self.viewModel = CharacterListViewModel()
    }
    
    // MARK: - Helpers
    func resetFlags() {
        didFetchCharactersCalled = false
        didPresentCharacterDetailCalled = false
        didOnFetchCharactersSuccessCalled = true
        didOnFetchCharactersFailureCalled = true
    }
    
    func fetchCharacters(searchTerm: String?, status: CharacterStatus?, shouldResetData: Bool) {
        didFetchCharactersCalled = true
    }
    
    func presentCharacterDetail(with navigationController: UINavigationController, characterInformation: CharacterInformation) {
        didPresentCharacterDetailCalled = true
    }
    
    func onFetchCharactersSuccess(response: CharacterListResponseModel) {
        didOnFetchCharactersSuccessCalled = true
    }
    
    func onFetchCharactersFailure(error: Error) {
        didOnFetchCharactersFailureCalled = true
    }
}
