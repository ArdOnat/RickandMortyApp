//
//  CharacterListRepository.swift
//  ArdaOnatOBSSCase
//
//  Created by Arda Onat on 20.05.2021.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import Foundation

protocol CharacterListRepositoryProtocol {
    var output: CharacterListRepositoryOutputProtocol? { get set }
    
    func fetchCharacters(with page: Int, searchTerm: String?, status: CharacterStatus?)
}

protocol CharacterListRepositoryOutputProtocol: class {
    func onFetchCharactersSuccess(response: CharacterListResponseModel)
    func onFetchCharactersFailure(error: Error)
}

final class CharacterListRepository: CharacterListRepositoryProtocol {
    
    // MARK: Private properties
    private let service: CharacterListServiceProtocol
    
    // MARK: Public properties
    weak var output: CharacterListRepositoryOutputProtocol?
    
    // MARK: Initializers
    init(service: CharacterListServiceProtocol) {
        self.service = service
    }
    
    func fetchCharacters(with page: Int, searchTerm: String?, status: CharacterStatus?) {
        service.fetchCharacters(with: page, searchTerm: searchTerm, status: status) { result in
            switch result {
            case .success(let response):
                self.output?.onFetchCharactersSuccess(response: response)
            case .failure(let error):
                self.output?.onFetchCharactersFailure(error: error)
            }
        }
    }
}
