//
//  ContentView.swift
//  ShoppingListApp
//
//  Created by Michal on 21/10/2022.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @State private var productName: String = ""

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.name, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Item>
    
    var body: some View {
            VStack {
                
                TextField("Enter product", text: $productName)
                    .textFieldStyle(.roundedBorder)
                
                NavigationView {
                    ZStack {
                        List {
                            Section{
                                ForEach(items) { item in
                                    if (item.done == false){
                                        HStack {
                                            Text(item.name ?? "")
                                            Spacer()
                                            Image(systemName: "square")
                                                .foregroundColor(.black)
                                                .onTapGesture {
                                                    updateTask(item)
                                                }
                                        }
                                    }                                }
                                .onDelete(perform: deleteItems)
                            }
                            Section{
                                ForEach(items) { item in
                                    if (item.done == true){
                                        HStack {
                                            
                                            Text(item.name ?? "")
                                            Spacer()
                                            Image(systemName: "checkmark.square")
                                                .foregroundColor(.black)
                                                .onTapGesture {
                                                    updateTask(item)
                                                }
                                        }
                                    }
                                }
                                .onDelete(perform: deleteItems)
                            }

                        }
                        .navigationTitle("Shopping List")
                        
                        .toolbar {
                            ToolbarItem {
                                Button(action: addItem) {
                                    Label("Add Item", systemImage: "plus")
                                        .foregroundColor(.black)
                                }
                            }
                        }
                        Spacer()
                    }
                }
                .navigationViewStyle(StackNavigationViewStyle())
                
                HStack {
                    Button(action: removeDone) {
                        Label("Remove Done", systemImage: "trash")
                            .frame(width: 150, height: 30)
                            .background(Color.gray)
                            .foregroundColor(Color.white)
                            .cornerRadius(10)


                    }
                    Button(action: removeAll) {
                        Label("Remove All", systemImage: "trash")
                            .frame(width: 150, height: 30)
                            .background(Color.gray)
                            .foregroundColor(Color.white)
                            .cornerRadius(10)


                    }
                }
                .padding(.bottom)
            }

        
    }
    
    private func updateTask(_ item: Item) {
        item.done = true
        
        do {
            try viewContext.save()
        } catch {
            print(error.localizedDescription)
        }
    }

    private func addItem() {
        if productName != "" {
        withAnimation {
                let newItem = Item(context: viewContext)
                //            newItem.name = "NowyKaramel"
                newItem.name = productName
                productName = ""
                newItem.done = false
                do {
                    try viewContext.save()
                } catch {
                    let nsError = error as NSError
                    fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
                }
            }
        }
    }
    
    private func removeAll() {
        withAnimation {
            for item in items {
                    viewContext.delete(item)
            }
            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
    private func removeDone() {
        withAnimation {
            for item in items {
                if(item.done == true) {
                    viewContext.delete(item)
                }
            }
            do {
                try viewContext.save()
            } catch {
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
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
