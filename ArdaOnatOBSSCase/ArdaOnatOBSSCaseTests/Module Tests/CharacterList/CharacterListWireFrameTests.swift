//
//  CharacterListWireFrameTests.swift
//  ArdaOnatOBSSCase
//
//  Created by Arda Onat on 23.05.2021.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

@testable import ArdaOnatOBSSCase

import XCTest

class CharacterListWireFrameTests: XCTestCase {

    // MARK: - Properties
    var wireframe: CharacterListWireframeProtocol!
    
    // MARK: - Life Cycle
    override func setUp() {
        super.setUp()
        
        wireframe = CharacterListWireframe()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    // MARK: - Tests
}
