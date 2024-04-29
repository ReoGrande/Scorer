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
    var currentGame: Game
    @State var showingPopup = false // 1
    @State var editingPlayer: Player = Player(name: "", score: 0)
    @State var editingScore: String = "0"
    
    var body: some View {
        List(currentGame.players, id: \.self) {
            player in
            HStack(alignment: .center, spacing: 20) {
                Text(player.name)
                Divider()
                Text(player.score.description).onTapGesture {
                    showingPopup = true
                    editingPlayer = player
                    editingScore = String(player.score)
                    //                }.onChange(of: editingPlayer.score) {
                    //                    player = editingPlayer.score
                    //                }
                    //NOT WORKING. TODO: MAKE CHANGE TO PLAYER APPLY TO VIEW AND DATA
                }
            }
        }.popover(isPresented: $showingPopup) {
            VStack(alignment: .leading){
                Color.red.opacity(0.2)
                Text("Player Name: \(editingPlayer.name)")
                TextField("Score: ", text: $editingScore).onSubmit {
                    showingPopup = false
                    editingPlayer.score = Int(editingScore) ?? editingPlayer.score
                    saveEdit()
                }
            }
        }
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    private func saveEdit() {
        var newPlayers:[Player] = []
        for p in currentGame.players {
            if p.hashValue == editingPlayer.hashValue {
                newPlayers.append(editingPlayer)
            } else {
                newPlayers.append(p)
            }
        }
        withAnimation {
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
