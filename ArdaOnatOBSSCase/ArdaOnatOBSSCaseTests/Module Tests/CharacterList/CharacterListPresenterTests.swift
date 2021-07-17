//
//  CharacterListPresenterTests.swift
//  ArdaOnatOBSSCase
//
//  Created by Arda Onat on 23.05.2021.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

@testable import ArdaOnatOBSSCase

import XCTest

class CharacterListPresenterTests: XCTestCase, CharacterDetailClosedDelegate {
    
    // MARK: - Properties
    var presenter: CharacterListPresenterProtocol!
    
    let fakeInteractor = FakeCharacterListInteractor()
    let fakeWireframe = FakeCharacterListWireframe()
    let fakeView = FakeCharacterListView()
    
    // MARK: - Life Cycle
    override func setUp() {
        super.setUp()
        
        presenter = CharacterListPresenter(interactor: fakeInteractor, wireframe: fakeWireframe)
        presenter.view = fakeView
    }
    
    override func tearDown() {
        super.tearDown()
        
        fakeInteractor.resetFlags()
        fakeWireframe.resetFlags()
        fakeWireframe.resetFlags()
    }
    
    func testDidFetchCharacters() {
        fakeInteractor.fetchCharacters(with: 0, searchTerm: nil, status: nil)
        XCTAssertTrue(fakeInteractor.didFetchCharactersCalled)
    }
    
    func testDidPresentCharacterDetailcalled() {
        let characterInformation = CharacterInformation(id: 0, name: "", status: "", species: "", image: "", episode: [], gender: "", origin: LocationInfo(name: ""), location: LocationInfo(name:""))
        fakeWireframe.presentCharacterDetail(with: UINavigationController(), characterInformation: characterInformation, closedDelegate: self)
        
        XCTAssertTrue(fakeWireframe.didPresentCharacterDetailCalled)
    }
    
    func testDidShowLoadingCalled() {
        fakeView.showLoading(shouldShow: true)
        XCTAssertTrue(fakeView.didShowLoading)
    }
    
    func testDidRefreshUIWithSuccessCalled() {
        fakeView.refreshUIWithSuccess()
        XCTAssertTrue(fakeView.didRefreshUIWithSuccess)
    }
    
    func testDidShowErrorCalled() {
        fakeView.showError()
        XCTAssertTrue(fakeView.didShowError)
    }
    
    func testDidRefreshSelectedCellCalled() {
        fakeView.refreshSelectedCell()
        XCTAssertTrue(fakeView.didRefreshSelectedCell)
    }
    
    func onCharacterDetailClose() {
    }
}
