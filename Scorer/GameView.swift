//
//  GameView.swift
//  Scorer
//
//  Created by user on 4/21/24.
//

import UIKit
import SwiftUI
import CoreData

struct GameView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @ObservedObject var currentGame: Game
    @State var showingPopup = false // 1
    @State var editingPlayer: Player = Player(name: "", score: 0, id: -1)
    @State var editingScore: Int = 0
    
    var body: some View {
        List(Array(currentGame.players.enumerated()), id: \.element.id) {
            index, player in
            HStack(alignment: .center, spacing: 20) {
                Text(player.name)
                Divider()
                Text(currentGame.players[index].score, format: .number).onTapGesture {
                    DispatchQueue.main.async {
                    editingPlayer = player
                    showingPopup = true
                    editingScore = player.score
                    }
                }
                Divider()
                
                    Button("+") {
                        increment(playerToInc: &currentGame.players[index])
                        print("Increase \(currentGame.players[index].score)")
                    }
                    .buttonStyle(BorderlessButtonStyle())

                Spacer()

                Button("-") {
                    editingPlayer = currentGame.players[index]
                    editingPlayer.score = editingPlayer.score - 1
                    currentGame.updateScore(editingPlayer)
                        print("Decrease \(editingPlayer.score)")
                    }
                    .buttonStyle(BorderlessButtonStyle())
                Spacer()
            }
        }.popover(isPresented: $showingPopup) {
            Color.red.opacity(0.2)
            VStack(alignment: .center){
                Text("Player Name: \(editingPlayer.name)")
                TextField("Score: ", value: $editingScore, format: .number)
                    .onSubmit {
                        showingPopup = false
                        editingPlayer.score = editingScore
                        currentGame.updateScore(editingPlayer)
                        print(editingPlayer.score)
                        saveGame()
                    }
            }
            .padding(20)
            Color.red.opacity(0.2)
        }
    }
    
    private func increment(playerToInc: inout Player) {
        playerToInc.score = playerToInc.score + 1
    }
    
    private func decrement(playerToDec: inout Player) {
        playerToDec.score = playerToDec.score - 1
    }

    
    private func saveGame(){
        withAnimation {

            guard let saveGame = viewContext.object(with: currentGame.data.objectID) as? Item else {
                // TODO: HANDLE ERROR
                return
            }
            
            let names: [String] = currentGame.players.map {
                $0.name
            }
            saveGame.players_names = names.joined(separator: " ")
            let scores: [String] = currentGame.players.map {
                String($0.score)
            }
            saveGame.game_scores = scores.joined(separator:" ")
            
            saveGame.game_name = currentGame.name

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }

}
