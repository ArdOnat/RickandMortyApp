//
//  CharacterListResponseModel.swift
//  ArdaOnatOBSSCase
//
//  Created by Arda Onat on 20.05.2021.
//

struct CharacterListResponseModel: Codable {
    let info: PageInformation
    let results: [CharacterInformation]
}

struct PageInformation: Codable {
    let count: Int
    let pages: Int
    let next: String?
    let prev: String?
}

struct CharacterInformation: Codable {
    let id: Int
    let name: String
    let status: String
    let species: String
    let image: String
    let episode: [String]
    let gender: String
    let origin: LocationInfo
    let location: LocationInfo
}

struct LocationInfo: Codable {
    let name: String
}
