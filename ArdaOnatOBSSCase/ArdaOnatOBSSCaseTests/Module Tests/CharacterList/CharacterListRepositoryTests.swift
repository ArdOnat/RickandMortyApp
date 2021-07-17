//
//  CharacterListRepositoryTests.swift
//  ArdaOnatOBSSCase
//
//  Created by Arda Onat on 23.05.2021.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

@testable import ArdaOnatOBSSCase
import Alamofire
import XCTest

class CharacterListRepositoryTests: XCTestCase {

    // MARK: - Properties
    var repository: CharacterListRepositoryProtocol!
    var output: FakeCharacterListInteractor!
    let fakeService = FakeCharacterListService()
    
    // MARK: - Life Cycle
    override func setUp() {
        super.setUp()
        
        repository = CharacterListRepository(service: fakeService)
        output = FakeCharacterListInteractor(repository: repository)
    }
    
    override func tearDown() {
        super.tearDown()
        
        fakeService.resetFlags()
    }
    
    // MARK: - Tests
    
    func testDidFetchCharactersCalled() {
        fakeService.fetchCharacters(with: 0, searchTerm: nil, status: nil, completion:{result in})
        XCTAssertTrue(fakeService.didFetchCharactersCalled)
    }
    
    func testDidOnFetchCharactersSuccess() {
        output?.onFetchCharactersSuccess(response: CharacterListResponseModel(info: PageInformation(count: 0, pages: 0, next: "", prev: ""), results: []))
        XCTAssertTrue(output.didOnFetchSuccessCalled)
    }
    
    func testDidOnFetchCharactersFailure() {
        output?.onFetchCharactersFailure(error: AFError.sessionDeinitialized)
        XCTAssertTrue(output.didOnFetchFailureCalled)
    }
}
