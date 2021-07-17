//
//  CharacterListWireframe.swift
//  ArdaOnatOBSSCase
//
//  Created by Arda Onat on 20.05.2021.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol CharacterListWireframeProtocol {
    func presentCharacterDetail(with navigationController: UINavigationController, characterInformation: CharacterInformation, closedDelegate: CharacterDetailClosedDelegate)
}

final class CharacterListWireframe: CharacterListWireframeProtocol {
    func presentCharacterDetail(with navigationController: UINavigationController, characterInformation: CharacterInformation, closedDelegate: CharacterDetailClosedDelegate) {
        guard let characterDetailVC = CharacterDetailModuleBuilder.generate(characterInformation: characterInformation, closedDelegate: closedDelegate) else { return }
        characterDetailVC.isModalInPresentation = true
        navigationController.present(characterDetailVC, animated: true)
    }
}
