//
//  CharacterDetailViewModel.swift
//  ArdaOnatOBSSCase
//
//  Created by Arda Onat on 21.05.2021.
//

import Foundation

struct CharacterDetailViewModel {
    
    var characterInformation: CharacterInformation?
    
    init(characterInformation: CharacterInformation) {
        self.characterInformation = characterInformation
    }
    
    var lastEpisodeURL: String {
        return characterInformation?.episode.last ?? ""
    }
    
    var lastEpisodeName: String {
        guard let lastEpisodeNumber = lastEpisodeURL.split(separator: "/").last else { return ""}
        return "Episode \(lastEpisodeNumber)"
    }
    
    var numberOfEpisodesText: String {
        return "Appeared in \(characterInformation?.episode.count ?? 0) episodes"
    }
    
    var originLocation: String {
        self.characterInformation?.origin.name ?? ""
    }
    
    var lastKnownLocation: String {
        self.characterInformation?.location.name ?? ""
    }
    
    func getIsFavorited(for characterId: Int) -> Bool {
        guard let favoritedCharactersId = UserDefaults.standard.object(forKey: UserDefaults.favoritedCharactersKey) as? [Int] else { return false }
        return favoritedCharactersId.contains(characterId)
    }
}
