//
//  CharacterListInteractorTests.swift
//  ArdaOnatOBSSCase
//
//  Created by Arda Onat on 23.05.2021.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

@testable import ArdaOnatOBSSCase

import Alamofire
import XCTest

class CharacterListInteractorTests: XCTestCase {

    // MARK: - Properties
    var interactor: CharacterListInteractorProtocol!
    
    let fakeRepository = FakeCharacterListRepository()
    let fakePresenter = FakeCharacterListPresenter()
    
    // MARK: - Life Cycle
    override func setUp() {
        super.setUp()
        
        interactor = CharacterListInteractor(repository: fakeRepository)
        interactor.output = fakePresenter
    }
    
    override func tearDown() {
        super.tearDown()
        
        fakeRepository.resetFlags()
        fakePresenter.resetFlags()
    }
    
    // MARK: - Tests
    
    func testDidFetchCharactersCalled() {
        fakeRepository.fetchCharacters(with: 0, searchTerm: nil, status: nil)
        XCTAssertTrue(fakeRepository.didFetchCharactersCalled)
    }
    
    func testDidOnFetchCharactersSuccess() {
        fakePresenter.onFetchCharactersSuccess(response: CharacterListResponseModel(info: PageInformation(count: 0, pages: 0, next: "", prev: ""), results: []))
        XCTAssertTrue(fakePresenter.didOnFetchCharactersSuccessCalled)
    }
    
    func testDidOnFetchCharactersFailure() {
        fakePresenter.onFetchCharactersFailure(error: AFError.sessionDeinitialized)
        XCTAssertTrue(fakePresenter.didOnFetchCharactersFailureCalled)
    }
}
