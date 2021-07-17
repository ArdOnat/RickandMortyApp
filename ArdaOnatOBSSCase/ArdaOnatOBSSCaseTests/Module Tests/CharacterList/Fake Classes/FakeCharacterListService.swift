//
//  FakeCharacterListService.swift
//  ArdaOnatOBSSCaseTests
//
//  Created by Arda Onat on 23.05.2021.
//

import Alamofire

@testable import ArdaOnatOBSSCase

class FakeCharacterListService: CharacterListServiceProtocol {
    
    var didFetchCharactersCalled: Bool = false
    
    func fetchCharacters(with page: Int, searchTerm: String?, status: CharacterStatus?, completion: @escaping (AFResult<CharacterListResponseModel>) -> ()) {
        didFetchCharactersCalled = true
    }
    
    func resetFlags() {
        didFetchCharactersCalled = false
    }
}
