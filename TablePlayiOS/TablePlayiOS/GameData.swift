//
//  GameData.swift
//  TablePlayiOS
//
//  Created by Nasif Zaman on 4/18/24.
//

import Foundation

struct GameInfo: Decodable{
    let gameId: Int
    let season: Int
    let week: Int
    let gameDate: String
    let gameTimeEastern: String
    let homeTeamAbbr: String
    let visitorTeamAbbr: String
}

struct SeasonInfo: Decodable{
    let year: [GameInfo]
}

class GameData{
    static func readFromJson()->SeasonInfo?{
        guard let path = Bundle.main.path(forResource: "games", ofType: "json") else {
            fatalError("Couldn't find games.json in the app bundle")
        }

        do {
            let data = try Data(contentsOf: URL(filePath: path))

            // Example: Convert the data to a dictionary and print its contents
            if let sinfo = try? JSONDecoder().decode(SeasonInfo.self, from: data) {
                return sinfo
            } else {
                print("Error converting data to JSON dictionary")
            }

        } catch {
            print("Error reading your_file_name.json: \(error)")
        }
        return nil
    }
    
    static func listGames()->[String]{
        guard let data = readFromJson() else{
            return ["No Game Data"]
        }
        var ls: [String] = []
        data.year.forEach{game in
            ls.append(game.homeTeamAbbr+" "+game.visitorTeamAbbr)
        }
        return ls
    }
}
