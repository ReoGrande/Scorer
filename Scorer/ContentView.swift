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
                    NavigationLink {
                        GameView(currentGame: Game(item: item))
                    } label: {
                            Text(item.game_name ?? "Reo wuz here")
                    }.onLongPressGesture {
                        print(item.timestamp)
                    }
                }
                .onDelete(perform: deleteItems)
            }.popover(isPresented: $showingPopup) {
                VStack {
                    Color.red.opacity(0.2)
                    TextField("Player Name", text: $playerName)
                    Button("Add Player") {
                        withAnimation{
                            playerNames.append(playerName.isEmpty ? "No Name" : playerName)
                            gameScores.append("0")
                            playerName = ""
                            print(playerNames)
                        }
                    }
                    List(playerNames, id: \.self) {
                        player in
                        withAnimation {
                            Text(player)
                        }
                    }
                    TextField("Game Name", text: $gameName)
                    Button("Create Game") {
                        //Game(item: newItem)
                        let newItem = Item(context: viewContext)
                        newItem.timestamp = Date()
                        newItem.players_names = playerNames.joined(separator: " ")
                        newItem.game_name = gameName
                        newItem.game_scores = gameScores.joined(separator:" ")
                        addItem(newItem)
                        showingPopup = false
                    }.onSubmit {
                        gameName = ""
                        playerNames = []
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Text("Games").bold()
                }
                ToolbarItem(placement: .topBarTrailing) {
                    EditButton()
                }
                ToolbarItem {
//                    Button(action: addItem) {
//                        Label("Add Item", systemImage: "plus")
//                    }
                    Button("Add Item", systemImage: "plus") {
                        showingPopup = true // 2
                    }
                }
            }
            Text("Select an item")
        }
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
