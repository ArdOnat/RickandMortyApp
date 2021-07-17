//
//  CharacterListModuleBuilder.swift
//  ArdaOnatOBSSCase
//
//  Created by Arda Onat on 20.05.2021.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

enum CharacterListModuleBuilder {
    static func generate() -> UIViewController? {
        
        let wireframe: CharacterListWireframeProtocol = CharacterListWireframe()
        let service: CharacterListServiceProtocol = CharacterListService()
        var repository: CharacterListRepositoryProtocol = CharacterListRepository(service: service)
        var interactor: CharacterListInteractorProtocol & CharacterListRepositoryOutputProtocol = CharacterListInteractor(repository: repository)
        let presenter: CharacterListPresenterProtocol & CharacterListInteractorOutputProtocol = CharacterListPresenter(interactor: interactor, wireframe: wireframe)
        let view: CharacterListViewProtocol = CharacterListViewController(presenter: presenter)
        
        presenter.view = view
        interactor.output = presenter
        repository.output = interactor
        
        return view as? UIViewController
    }
}
