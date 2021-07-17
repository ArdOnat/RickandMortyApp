//
//  CharacterListInteractor.swift
//  ArdaOnatOBSSCase
//
//  Created by Arda Onat on 20.05.2021.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import Foundation

protocol CharacterListInteractorProtocol {
    var repository: CharacterListRepositoryProtocol { get }
    var output: CharacterListInteractorOutputProtocol? { get set }
    
    func fetchCharacters(with page: Int, searchTerm: String?, status: CharacterStatus?)
}

protocol CharacterListInteractorOutputProtocol: class {
    func onFetchCharactersSuccess(response: CharacterListResponseModel)
    func onFetchCharactersFailure(error: Error)
}

final class CharacterListInteractor: CharacterListInteractorProtocol {
    
    // MARK: Public properties
    let repository: CharacterListRepositoryProtocol
    weak var output: CharacterListInteractorOutputProtocol?
    
    // MARK: Initializers
    init(repository: CharacterListRepositoryProtocol) {
        self.repository = repository
    }
    
    func fetchCharacters(with page: Int, searchTerm: String? = nil, status: CharacterStatus? = nil) {
        repository.fetchCharacters(with: page, searchTerm: searchTerm, status: status)
    }
}

extension CharacterListInteractor: CharacterListRepositoryOutputProtocol {
    func onFetchCharactersSuccess(response: CharacterListResponseModel) {
        output?.onFetchCharactersSuccess(response: response)
    }
    
    func onFetchCharactersFailure(error: Error) {
        output?.onFetchCharactersFailure(error: error)
    }
}
