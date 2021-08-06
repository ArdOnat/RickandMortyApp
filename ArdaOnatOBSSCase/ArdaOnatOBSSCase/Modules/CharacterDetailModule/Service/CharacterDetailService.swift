//
//  CharacterDetailService.swift
//  ArdaOnatOBSSCase
//
//  Created by Arda Onat on 20.05.2021.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import AONetworkLayer
import Foundation

protocol CharacterDetailServiceProtocol {
    func fetchEpisodeInformation(with url: String, completion: @escaping (Result<EpisodeResponseModel, NetworkError>) -> ())
}

final class CharacterDetailService: CharacterDetailServiceProtocol {
    func fetchEpisodeInformation(with url: String, completion: @escaping (Result<EpisodeResponseModel, NetworkError>) -> ()) {
        guard let episodeURL = URL(string: url) else {
            completion(.failure(.missingURL))
            return
        }
        NetworkLayer.shared.request(requestURL: episodeURL, completion: completion)
    }
}
