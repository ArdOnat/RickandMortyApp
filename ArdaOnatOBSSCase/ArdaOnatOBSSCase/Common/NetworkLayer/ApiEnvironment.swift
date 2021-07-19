//
//  NetworkEnvironment.swift
//  ArdaOnatOBSSCase
//
//  Created by Arda Onat on 18.07.2021.
//

enum ApiEnvironment {
    case rickAndMortyApi(environmentType: NetworkEnvironmentType)
    
    var baseURL: String {
        switch self {
        case .rickAndMortyApi(let environmentType):
            switch environmentType {
            case .production, .qa, .test:
                return "https://rickandmortyapi.com/api/"
            }
        }
    }
}

enum NetworkEnvironmentType: String {
    case production
    case qa
    case test
}
