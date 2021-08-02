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
        case .rickAndMortyApi(.production):
            return "https://rickandmortyapi.com/api/"
        case .rickAndMortyApi(.qa):
            return "https://rickandmortyapi.com/api/"
        case .rickAndMortyApi(.test):
            return "https://rickandmortyapi.com/api/"
        }
    }
}

enum NetworkEnvironmentType {
    case production
    case qa
    case test
}
