//
//  CharacterListServiceTests.swift
//  ArdaOnatOBSSCase
//
//  Created by Arda Onat on 23.05.2021.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

@testable import ArdaOnatOBSSCase

import XCTest

class CharacterListServiceTests: XCTestCase {

    // MARK: - Properties
    var service: CharacterListServiceProtocol!
    
    // MARK: - Life Cycle
    override func setUp() {
        super.setUp()
        
        service = CharacterListService()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    // MARK: - Tests
    func testFetchCharacterList() {
        let expectation = XCTestExpectation(description: "Fetch Character List")
        service.fetchCharacters(with: 0, searchTerm: nil, status: nil){ result in
            switch result {
            case .success(let response):
                XCTAssertTrue(response.info.next != nil)
                expectation.fulfill()
            case .failure(_):
                expectation.fulfill()
            }
        }
        wait(for: [expectation], timeout: 10.0)
    }
}
