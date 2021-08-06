//
//  CharacterListService.swift
//  ArdaOnatOBSSCase
//
//  Created by Arda Onat on 20.05.2021.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import Foundation
import AONetworkLayer

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

enum CharacterListRequest: Request {
    case fetchCharacters(page: Int, searchTerm: String?, status: CharacterStatus?)
    
    var environmentBaseURL : String {
        //TODO: Get environment
        switch self {
            case .fetchCharacters(_, _, _): return ApiEnvironment.rickAndMortyApi(environmentType: .production).baseURL
        }
    }
    
    var baseURL: URL {
        guard let url = URL(string: environmentBaseURL) else { fatalError("baseURL could not be configured.") }
        return url
    }
    
    var path: String {
        switch self {
        case .fetchCharacters(_, _, _):
            return "character"
        }
    }
    
    var httpMethod: HTTPMethods {
        return .GET
    }
    
    var urlParameters: Parameters? {
        switch self {
        case .fetchCharacters(let page, let searchTerm, let status):
            var urlParameters: Parameters = Parameters()
            urlParameters["page"] = page
            
            if let searchTerm = searchTerm {
                urlParameters["name"] = searchTerm
            }
            
            if let status = status {
                urlParameters["status"] = status.parameterValue
            }
            
            return urlParameters
        }
    }
    
    var bodyParameters: Parameters? {
        return nil
    }
    
    var httpHeaders: HTTPHeaders? {
        return nil
    }
}


protocol CharacterListServiceProtocol {
    func fetchCharacters(with page: Int, searchTerm: String?, status: CharacterStatus?, completion: @escaping (Result<CharacterListResponseModel, NetworkError>) -> ())
}

final class CharacterListService: CharacterListServiceProtocol {
    
    func fetchCharacters(with page: Int, searchTerm: String?, status: CharacterStatus?, completion: @escaping (Result<CharacterListResponseModel, NetworkError>) -> ()) {
        NetworkLayer.shared.request(CharacterListRequest.fetchCharacters(page: page, searchTerm: searchTerm, status: status), completion: completion)
    }
}
