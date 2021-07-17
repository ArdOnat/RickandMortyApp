//
//  FakeCharacterListWireframe.swift
//  ArdaOnatOBSSCase
//
//  Created by Arda Onat on 23.05.2021.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
@testable import ArdaOnatOBSSCase

class FakeCharacterListWireframe: CharacterListWireframeProtocol {

    // MARK: - Properties
    
    // MARK: - Test Properties
    var didPresentCharacterDetailCalled = false
    
    // MARK: - Initializer
    init() {
        
    }
    
    // MARK: - Helpers
    func resetFlags() {
        didPresentCharacterDetailCalled = false
    }
    
    func presentCharacterDetail(with navigationController: UINavigationController, characterInformation: CharacterInformation, closedDelegate: CharacterDetailClosedDelegate) {
        didPresentCharacterDetailCalled = true
    }
}
