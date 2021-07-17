//
//  CharacterListViewTests.swift
//  ArdaOnatOBSSCase
//
//  Created by Arda Onat on 23.05.2021.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

@testable import ArdaOnatOBSSCase

import XCTest

class CharacterListViewTests: XCTestCase {

    // MARK: - Properties
    var view: CharacterListViewController!
    
    let fakePresenter = FakeCharacterListPresenter()
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
    
    // MARK: - Life Cycle
    override func setUp() {
        super.setUp()
        
        self.view = CharacterListViewController(presenter: fakePresenter)
        fakePresenter.viewModel?.addCharacters(characters: [CharacterInformation(id: 0, name: "", status: "", species: "", image: "", episode: [], gender: "", origin: LocationInfo(name: ""), location: LocationInfo(name:""))])
        fakePresenter.viewModel?.lastPageInfo = PageInformation(count: 20, pages: 20, next: "some", prev: "some")
        
        collectionView.delegate = view
        collectionView.dataSource = view
        collectionView.register(UINib(nibName: CharacterListCollectionViewCell.ReuseIdentifier, bundle: Bundle.main), forCellWithReuseIdentifier: CharacterListCollectionViewCell.ReuseIdentifier)
    }
    
    override func tearDown() {
        super.tearDown()
        
        fakePresenter.resetFlags()
    }
    
    // MARK: - Tests
    func testInitFromCoder() {
        let view = CharacterListViewController(coder: NSCoder())
        XCTAssertNil(view)
    }
    
    func testDidFetchCharactersCalled() {
        fakePresenter.fetchCharacters(searchTerm: nil, status: nil, shouldResetData: false)
        XCTAssertTrue(fakePresenter.didFetchCharactersCalled)
    }
    
    func testDidPresentCharacterDetailCalled() {
        fakePresenter.presentCharacterDetail(with: UINavigationController(), characterInformation: CharacterInformation(id: 0, name: "", status: "", species: "", image: "", episode: [], gender: "", origin: LocationInfo(name: ""), location: LocationInfo(name:"")))
        XCTAssertTrue(fakePresenter.didPresentCharacterDetailCalled)
        fakePresenter.resetFlags()
    }
    
    func testNumberOfItems() {
        XCTAssertEqual(self.collectionView.dataSource?.collectionView(self.collectionView, numberOfItemsInSection: 0), 1)
    }
    
    func testPagination() {
        self.collectionView.delegate?.collectionView?(self.collectionView, willDisplay: UICollectionViewCell(), forItemAt: IndexPath(row: 0, section: 0))
        XCTAssertTrue(fakePresenter.didFetchCharactersCalled)
        fakePresenter.resetFlags()
    }
}
