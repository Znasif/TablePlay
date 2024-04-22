//
//  GameData.swift
//  TablePlayiOS
//
//  Created by Nasif Zaman on 4/18/24.
//

import Foundation

struct GameInfo: Decodable{
    let games: [Int]
}

struct Game: Decodable {
  let gameId: Int
  let plays: [Play]
}

struct Play: Decodable {
  let home: [Player]
  let away: [Player]
  let football: Locomotion
  let description: Description
}

struct Player: Decodable {
  let playerId: String
  let locomotion: Locomotion
}

struct Locomotion: Decodable {
  let x: [Float]
  let y: [Float]
  let orientation: [Float]?
}

struct Description: Decodable {
  let events: [String]
  let eventTime: [Int]
  let direction: String
  let homeTeamAbbr: String
  let visitorTeamAbbr: String
  let week: Int
}

class GameData{
    static var games: [Game] = []
    static var selectedGame = 0
    static func readFromJson()->GameInfo?{
        guard let path = Bundle.main.path(forResource: "nfl", ofType: "json") else {
            fatalError("Couldn't find games.json in the app bundle")
        }
        do {
            let data = try Data(contentsOf: URL(filePath: path))
            // Example: Convert the data to a dictionary and print its contents
            do {
                let ginfo = try JSONDecoder().decode(GameInfo.self, from: data)
                return ginfo
            } catch {
                print("Error decoding GameInfo:", error)
            }

        } catch {
            print("Error reading games.json: \(error)")
        }
        return nil
    }
    
    static func listGames()->[String]{
        guard let data = readFromJson() else{
            return ["NEV CAL"]
        }
        var ls: [String] = []
        data.games.forEach{gamepath in
            guard let path = Bundle.main.path(forResource: String(gamepath), ofType: "json") else {
                fatalError("Couldn't find \(gamepath) in the app bundle")
            }
            do {
                let gdata = try Data(contentsOf: URL(filePath: path))

                // Example: Convert the data to a dictionary and print its contents
                if let gamedata = try? JSONDecoder().decode(Game.self, from: gdata) {
                    games.append(gamedata)
                    ls.append(gamedata.plays[0].description.homeTeamAbbr+" "+gamedata.plays[0].description.visitorTeamAbbr+" "+String(gamepath)+" "+String(gamedata.plays[0].description.week))
                } else {
                    print("Error converting \(gamepath) to JSON dictionary")
                }

            } catch {
                print("Error reading your_file_name.json: \(error)")
            }
        }
        return ls
    }
    
    static func listPlays(gameId: Int)-> [Int]{
        var ls: [Int] = []
        for j in 0..<games.count{
            if games[j].gameId==gameId {
//                game.plays.forEach{play in
//                    ls.append("Game Event: "+String(play.description.events[0]))
//                }
                for i in 0..<games[j].plays.count {
                    ls.append(i)
                }
                selectedGame = j
                break
            }
//            ls.insert(game.plays[0].description.homeTeamAbbr)
//            ls.insert(game.plays[0].description.visitorTeamAbbr)
        }
//        return ls.map { String($0) } // Convert Set elements to strings
//            .sorted()
        return ls
    }
}


class FormationController{
    
}
