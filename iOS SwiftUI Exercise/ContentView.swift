//
//  ContentView.swift
//  iOS SwiftUI Exercise
//
//  Created by Bekzod Rakhmatov on 19/12/23.
//

import SwiftUI
import CoreData

struct ContentView: View {
    
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Item>
    
    @State var selectedItem: Item?
    @State var showDetailView = false
    @State var takePhoto = false
    @State var selectedImage: UIImage?

    var body: some View {
        VStack {
            NavigationTitleView(title: "Main")
                .padding(.horizontal)
            VStack {
                ItemListView()
                if let selectedImage = selectedImage {
                    Image(uiImage: selectedImage)
                        .resizable()
                        .frame(width: 100, height: 100)
                }
//                Button {
//                    selectedItem = nil
//                    showDetailView = true
//                } label: {
//                    Text("Add New Item")
//                }
                Button {
                takePhoto = true
                } label: {
                    Text("Select Image")
                }
            }
            .frame(maxHeight: .infinity)
        }
        .sheet(isPresented: $takePhoto) {
            ImagePicker(mode: .openPhotos, selectedImage: $selectedImage, cancelHandler: {
                
            })
                .ignoresSafeArea()
        }
        .sheet(isPresented: $showDetailView, content: {
            ItemDetailsView(item: $selectedItem)
                .environment(\.managedObjectContext, viewContext)
        })
    }
    
    @ViewBuilder func ItemListView() -> some View {
        if items.isEmpty {
            Text("No items")
                .frame(maxHeight: .infinity)
        } else {
            List {
                ForEach(items) { item in
                    Button {
                        selectedItem = item
                        showDetailView = true
                    } label: {
                        VStack {
                            Text(item.brand ?? "")
                                .font(.system(size: 20))
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .foregroundStyle(.black)
                            Text(item.model ?? "")
                                .font(.system(size: 17))
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .foregroundStyle(.gray)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
                .onDelete(perform: deleteItems)
            }
            .listStyle(.plain)
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map {
                items[$0]
            }
            .forEach(viewContext.delete)
            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

#Preview {
    ContentView()
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
