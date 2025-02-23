//
//  ContentView.swift
//  Scorer
//
//  Created by Reo Ogundare on 2/17/24.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Item>
    @State var showingPopup = false // 1
    @State var gameName = ""
    @State var playerName = ""
    @State var playerNames: [String] = []
    @State var gameScores: [String] = []

    var body: some View {
        NavigationView {
            List {
                ForEach(items) { item in
                    NavigationLink(item.game_name ?? "Reo wuz here") {
                        GameView(currentGame: Game(item: item))
                    }
                }
                .onDelete(perform: deleteItems)
            }.popover(isPresented: $showingPopup) {
                Spacer()
                Text("Create Game")
                VStack(alignment: .center, spacing: 20) {
                    Spacer()
                    TextField("Player Name", text: $playerName)
                        .onSubmit {
                          addPlayer()
                        }
                    Button("Add Player") {
                        addPlayer()
                    }
                    List(playerNames, id: \.self) {
                        player in
                        withAnimation {
                            Text(player)
                        }
                    }
                    TextField("Game Name", text: $gameName)
                        .onSubmit {
                            createGame()
                        }
                    Button("Create Game") {
                        //Game(item: newItem)
                        createGame()
                    }.onSubmit {
                        DispatchQueue.main.async {
                            gameName = ""
                            playerNames = []
                        }
                    }
                    Spacer()
                }
                .background(Color.secondary.opacity(0.2))

            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Text("Games").bold()
                }
                ToolbarItem(placement: .topBarTrailing) {
                    EditButton()
                }
                ToolbarItem {
                    Button("Add Item", systemImage: "plus") {
                        showingPopup = true // 2
                    }
                }
            }
            Text("Select an item")
        }
    }
    
    private func addPlayer() {
        withAnimation{
            playerNames.append(playerName.isEmpty ? "Player\(playerNames.count + 1)" : playerName)
            gameScores.append("0")
            playerName = ""
            print(playerNames)
        }
    }
    
    private func createGame() {
        let newItem = Item(context: viewContext)
        newItem.timestamp = Date()
        newItem.players_names = playerNames.joined(separator: " ")
        newItem.game_name = gameName.isEmpty ? "NewGame \(newItem.timestamp!.formatted(.dateTime))" : gameName
        newItem.game_scores = gameScores.joined(separator:" ")
        addItem(newItem)
        showingPopup = false
    }

    private func addItem(_ newItem: Item) {
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

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { items[$0] }.forEach(viewContext.delete)

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

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

#Preview {
    ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
