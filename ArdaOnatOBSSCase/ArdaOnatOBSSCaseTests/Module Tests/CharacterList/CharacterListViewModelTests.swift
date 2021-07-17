//
//  CharacterListViewModelTests.swift
//  ArdaOnatOBSSCaseTests
//
//  Created by Arda Onat on 23.05.2021.
//

import XCTest
@testable import ArdaOnatOBSSCase

class CharacterListViewModelTests: XCTestCase {

    var viewModel = CharacterListViewModel()
    var response: CharacterListResponseModel!
    
    override func setUp() {
        super.setUp()
        
        response = CharacterListTestUtils.mockCharacterListResponse()
        viewModel.lastPageInfo = response.info
        viewModel.characters = response.results
    }
    
    func testIsLastpage() {
        XCTAssertFalse(viewModel.isLastPage)
    }
    
    
    func testCharacterCount() {
        XCTAssertEqual(1, viewModel.characterCount)
    }
    
    func testGetCharacterInformation() {
        XCTAssertNotNil(viewModel.getCharacterInformation(at: IndexPath(row:0, section:0)))
    }
    
    func testGetEpisodeCountOfCharacter() {
        XCTAssertEqual(1, viewModel.getEpisodeCountOfCharacter(at: IndexPath(row:0, section:0)))
    }
    
    func testAddCharacters() {
        viewModel.addCharacters(characters: [CharacterInformation(id: 0, name: "", status: "", species: "", image: "", episode: [], gender: "", origin: LocationInfo(name: ""), location: LocationInfo(name: ""))])
                XCTAssertEqual(2, viewModel.characterCount)
    }
    
    func testClearData() {
        viewModel.clearData()
        XCTAssertEqual(0, viewModel.characterCount)
    }
}
