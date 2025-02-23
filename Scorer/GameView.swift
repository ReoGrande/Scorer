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
    @State var keyBoardShowing = false
    @State var editingPlayer: Player = Player(name: "Default", score: 0, id: -1)
    @State var editingScore: Int = 0
    
    var body: some View {
        List(Array(currentGame.players.enumerated()), id: \.element.id) {
            index, player in
            VStack(alignment: .trailing) {
                HStack(alignment: .center, spacing: 20) {
                    Section {
                        Text(player.name)
                    }
                    Spacer()
                    Text(currentGame.players[index].score, format: .number).onTapGesture {
                        DispatchQueue.main.async {
                            editingPlayer = player
                            editingScore = player.score
                        }
                        showingPopup = true
                    }
                    Spacer()
                    Button("+") {
                        increment(playerToInc: &currentGame.players[index])
                        print("Increase \(currentGame.players[index].score)")
                    }
                    .buttonStyle(BorderlessButtonStyle())
                    
                    Divider()
                    
                    Button("-") {
                        editingPlayer = currentGame.players[index]
                        editingPlayer.score = editingPlayer.score - 1
                        currentGame.updateScore(editingPlayer)
                        print("Decrease \(editingPlayer.score)")
                    }
                    .buttonStyle(BorderlessButtonStyle())
                }
            }
        }
        .navigationTitle(currentGame.name)
        .popover(isPresented: $showingPopup) {
            VStack (spacing: 20) {
                Spacer()
                Text("Player Name: \($editingPlayer.wrappedValue.name)")
                Spacer()
                HStack(alignment: .center, spacing: 20) {
                    Spacer()
                    Section {
                        TextField("Current score: ", value: $editingScore, format: .number)
                            .keyboardType(.numberPad)
                            .onTapGesture {
                                keyBoardShowing = true
                            }
                    }
                    .border(Color.black, width: 2)
                    Section {
                        Button("Done") {
                            showingPopup = false
                            editingPlayer.score = editingScore
                            currentGame.updateScore(editingPlayer)
                            keyBoardShowing = false
                            print(editingPlayer.score)
                            saveGame()
                        }
                        .disabled(!keyBoardShowing)
                        .buttonStyle(BorderlessButtonStyle())
                    }
                    Spacer()
                }
                Spacer()
            }
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
