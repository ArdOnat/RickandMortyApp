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
        guard let episodeURL = url.url else {
            completion(.failure(.invalidURL(url: url)))
            return
        }
        
        AF.request(episodeURL, method: .get).validate().responseDecodable(of: EpisodeResponseModel.self) { response in
            completion(response.result)
        }
    }
}
