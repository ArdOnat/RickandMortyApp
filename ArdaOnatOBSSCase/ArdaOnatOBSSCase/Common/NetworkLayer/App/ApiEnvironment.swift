//
//  NetworkEnvironment.swift
//  ArdaOnatOBSSCase
//
//  Created by Arda Onat on 18.07.2021.
//

import AONetworkLayer

struct RickAndMortyApi: ApiEnvironmentProtocol {
    var environmentType: NetworkEnvironmentProtocol
    
    init(_ environmentType: NetworkEnvironmentProtocol) {
        self.environmentType = environmentType
    }
}

enum RickAndMortyNetworkEnvironment: NetworkEnvironmentProtocol {
    case prod
    case qa
    case test
    case custom(environmentURL: String)
    
    var baseURL: String {
        switch self {
        case .prod: return "https://rickandmortyapi.com/api/"
        case .qa: return "https://rickandmortyapi.com/api/"
        case .test: return "https://rickandmortyapi.com/api/"
        case .custom(let environmentURL): return environmentURL
        }
    }
}
