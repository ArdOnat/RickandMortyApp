//
//  CharacterDetailService.swift
//  ArdaOnatOBSSCase
//
//  Created by Arda Onat on 20.05.2021.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import Foundation
import Alamofire

protocol CharacterDetailServiceProtocol {
    func fetchEpisodeInformation(with url: String, completion: @escaping (AFResult<EpisodeResponseModel>) -> ())
}

final class CharacterDetailService: CharacterDetailServiceProtocol {
    func fetchEpisodeInformation(with url: String, completion: @escaping (AFResult<EpisodeResponseModel>) -> ()) {
        guard let episodeURL = URL(string: url) else {
            completion(.failure(.invalidURL(url: url)))
            return
        }
        NetworkLayer.shared.request(requestURL: episodeURL, completion: completion)
    }
}
