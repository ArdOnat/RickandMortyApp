//
//  CharacterListViewModel.swift
//  ArdaOnatOBSSCase
//
//  Created by Arda Onat on 20.05.2021.
//

import Foundation

struct CharacterListViewModel {
    
    var characters = [CharacterInformation]()
    var lastPageInfo: PageInformation?

    var characterCount: Int {
        return characters.count
    }
    
    var favoritedCharactersId: [Int] {
        guard let favoritedCharactersId = UserDefaults.standard.object(forKey: UserDefaults.favoritedCharactersKey) as? [Int] else { return [] }
        return favoritedCharactersId
    }
    
    var isLastPage: Bool {
        guard let lastPageInfo = lastPageInfo else { return true }
        return lastPageInfo.next == nil
    }
    
    func getCharacterInformation(at index: IndexPath) -> CharacterInformation? {
        guard characterCount > 0 else { return nil}
        return characters[index.row]
    }
    
    func getEpisodeCountOfCharacter(at index: IndexPath) -> Int {
        return characters[index.row].episode.count
    }
    
    mutating func addCharacters(characters: [CharacterInformation]) {
        self.characters.append(contentsOf: characters)
    }
    
    mutating func clearData() {
        self.characters = []
    }
}
