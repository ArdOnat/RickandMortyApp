//
//  FakeCharacterListInteractor.swift
//  ArdaOnatOBSSCase
//
//  Created by Arda Onat on 23.05.2021.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

@testable import ArdaOnatOBSSCase

class FakeCharacterListInteractor: CharacterListInteractorProtocol, CharacterListRepositoryOutputProtocol{
    
    
    // MARK: - Properties
    var repository: CharacterListRepositoryProtocol
    var output: CharacterListInteractorOutputProtocol?
    
    // MARK: - Test Properties
    var didFetchCharactersCalled: Bool = false
    var didOnFetchSuccessCalled: Bool = false
    var didOnFetchFailureCalled: Bool = false
    
    // MARK: - Initializers
    required init(repository: CharacterListRepositoryProtocol) {
        self.repository = repository
        self.output = FakeCharacterListIneractorOutput()
    }
    
    init() {
        self.repository = FakeCharacterListRepository()
        self.output = FakeCharacterListIneractorOutput()
    }
    
    // MARK: - Helpers
    func resetFlags() {
        didFetchCharactersCalled = false
        didOnFetchSuccessCalled = false
        didOnFetchFailureCalled = false
    }
    
    func fetchCharacters(with page: Int, searchTerm: String?, status: CharacterStatus?) {
        didFetchCharactersCalled = true
    }
    
    func onFetchCharactersSuccess(response: CharacterListResponseModel) {
        didOnFetchSuccessCalled = true
    }
    
    func onFetchCharactersFailure(error: Error) {
        didOnFetchFailureCalled = true
    }
}
