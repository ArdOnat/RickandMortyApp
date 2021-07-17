//
//  FakeCharacterListRepository.swift
//  ArdaOnatOBSSCase
//
//  Created by Arda Onat on 23.05.2021.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

@testable import ArdaOnatOBSSCase

class FakeCharacterListRepository: CharacterListRepositoryProtocol {
    
    // MARK: - Properties
    var output: CharacterListRepositoryOutputProtocol?
    
    // MARK: - Test Properties
    var didFetchCharactersCalled: Bool = false
    
    // MARK: - Initializers
    required init() {
        
    }
    
    // MARK: - Helpers
    func resetFlags() {
        didFetchCharactersCalled = false
    }
    
    func fetchCharacters(with page: Int, searchTerm: String?, status: CharacterStatus?) {
        didFetchCharactersCalled = true
    }
}
