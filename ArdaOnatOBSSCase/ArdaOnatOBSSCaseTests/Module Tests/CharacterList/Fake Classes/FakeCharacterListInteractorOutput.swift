//
//  FakeCharacterListInteractorOutput.swift
//  ArdaOnatOBSSCase
//
//  Created by Arda Onat on 23.05.2021.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

@testable import ArdaOnatOBSSCase

import Foundation

class FakeCharacterListIneractorOutput: CharacterListInteractorOutputProtocol {
    
    // MARK: - Properties
    
    // MARK: - Test Properties
    var didOnFetchCharactersSuccessCalled: Bool = false
    var didOnFetchCharactersFailureCalled: Bool = false
    
    // MARK: - Initializer
    init() {
        
    }
    
    // MARK: - Helpers
    func resetFlags() {
        didOnFetchCharactersSuccessCalled = false
        didOnFetchCharactersFailureCalled = false
    }
    
    func onFetchCharactersSuccess(response: CharacterListResponseModel) {
        didOnFetchCharactersSuccessCalled = true
    }
    
    func onFetchCharactersFailure(error: Error) {
        didOnFetchCharactersFailureCalled = true
    }
}
