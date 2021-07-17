//
//  FakeCharacterListView.swift
//  ArdaOnatOBSSCase
//
//  Created by Arda Onat on 23.05.2021.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

@testable import ArdaOnatOBSSCase

class FakeCharacterListView: CharacterListViewProtocol {
    
    var didRefreshUIWithSuccess: Bool = false
    var didShowLoading: Bool = false
    var didShowError: Bool = false
    var didRefreshSelectedCell: Bool = false
    
    // MARK: - Properties
    var presenter: CharacterListPresenterProtocol
    
    // MARK: - Test Properties
    
    // MARK: - Initializers
    required init(presenter: CharacterListPresenterProtocol) {
        self.presenter = presenter
    }
    
    init() {
        self.presenter = FakeCharacterListPresenter()
    }
    
    // MARK: - Helpers
    func resetFlags() {
        didRefreshUIWithSuccess = false
        didShowLoading = false
        didShowError = false
        didRefreshSelectedCell = false
    }
    
    func refreshUIWithSuccess() {
        didRefreshUIWithSuccess = true
    }
    
    func showLoading(shouldShow: Bool) {
        didShowLoading = true
    }
    
    func showError() {
        didShowError = true
    }
    
    func refreshSelectedCell() {
        didRefreshSelectedCell = true
    }
}
