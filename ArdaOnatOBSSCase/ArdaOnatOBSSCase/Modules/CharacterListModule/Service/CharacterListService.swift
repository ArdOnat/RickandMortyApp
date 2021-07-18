//
//  CharacterListService.swift
//  ArdaOnatOBSSCase
//
//  Created by Arda Onat on 20.05.2021.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import Foundation
import Alamofire

enum CharacterStatus: String {
    case Alive
    case Dead
    case Unknown
    
    var parameterValue: String {
        switch self {
        case .Alive: return "alive"
        case .Dead: return "dead"
        case .Unknown: return "unknown"
        }
    }
}

protocol CharacterListServiceProtocol {
    func fetchCharacters(with page: Int, searchTerm: String?, status: CharacterStatus?, completion: @escaping (AFResult<CharacterListResponseModel>) -> ())
}

final class CharacterListService: CharacterListServiceProtocol {
    
    private struct Constants {
        static let characterEndpoint: String = "https://rickandmortyapi.com/api/character"
    }
    
    func fetchCharacters(with page: Int, searchTerm: String?, status: CharacterStatus?, completion: @escaping (AFResult<CharacterListResponseModel>) -> ()) {

        NetworkLayer.shared.request(EndPoints.fetchCharacters(page: page, searchTerm: searchTerm, status: status), completion: completion)
    }
}
