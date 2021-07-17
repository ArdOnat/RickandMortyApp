//
//  CharacterDetailModuleBuilder.swift
//  ArdaOnatOBSSCase
//
//  Created by Arda Onat on 20.05.2021.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

enum CharacterDetailModuleBuilder {
    static func generate(characterInformation: CharacterInformation, closedDelegate: CharacterDetailClosedDelegate) -> UIViewController? {
        let service: CharacterDetailServiceProtocol = CharacterDetailService()
        var repository: CharacterDetailRepositoryProtocol = CharacterDetailRepository(service: service)
        var interactor: CharacterDetailInteractorProtocol & CharacterDetailRepositoryOutputProtocol = CharacterDetailInteractor(repository: repository)
        let presenter: CharacterDetailPresenterProtocol & CharacterDetailInteractorOutputProtocol = CharacterDetailPresenter(interactor: interactor, characterInformation: characterInformation)
        let view: CharacterDetailViewProtocol = CharacterDetailViewController(presenter: presenter, closedDelegate: closedDelegate)
        
        presenter.view = view
        interactor.output = presenter
        repository.output = interactor
        
        return view as? UIViewController
    }
}
