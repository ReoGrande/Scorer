//
//  GameController.swift
//  Scorer
//
//  Created by Reo Ogundare on 4/21/24.
//

import Foundation
import SwiftUI

class Game {
    var name: String = ""
    var players: [Player] = []
//    var scores: [String] = []
    
    init(item: Item) {
        name = item.game_name ?? ""
        let tempPlayers = item.players_names?.components(separatedBy: " ") ?? []
        let tempScores = getScores(item.game_scores?.components(separatedBy: " ") ?? [], tempPlayers.count)
        for i in 0...tempPlayers.count-1 {
            players.append(Player(name: tempPlayers[i], score: tempScores[i]))
        }
    }
    
    private func getScores ( _ scores: [String], _ count: Int) -> [Int] {
        var tempScores: [Int] = []
        for i in 0...count {
            if i < scores.count {
                tempScores.append(Int(scores[i]) ?? 0)
            } else {
                tempScores.append(0)
            }
        }
        return tempScores
    }
    
    init() {
        name = "Empty game"
        players = []
//        scores = []
    }
}
