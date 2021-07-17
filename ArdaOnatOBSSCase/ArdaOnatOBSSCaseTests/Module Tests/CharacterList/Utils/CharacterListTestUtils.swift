//
//  CharacterListTestUtils.swift
//  ArdaOnatOBSSCaseTests
//
//  Created by Arda Onat on 23.05.2021.
//

import Foundation
@testable import ArdaOnatOBSSCase

enum CharacterListResponseType: String {
    case characterList = "CharacterList"
}

enum CharacterListTestUtils {
    private static func jsonData(_ responseType: CharacterListResponseType) -> Data? {
            guard let path = Bundle.main.path(forResource: responseType.rawValue, ofType: "json") else { return nil }
            return try? Data(contentsOf: URL(fileURLWithPath: path) as URL, options: .alwaysMapped)
    }
        
    static func mockCharacterListResponse() -> CharacterListResponseModel? {
        guard let data = jsonData(.characterList) else { return nil }
        let decoder = JSONDecoder()
        return try? decoder.decode(CharacterListResponseModel.self, from: data)
    }
}
