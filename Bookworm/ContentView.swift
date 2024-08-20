//
//  ContentView.swift
//  Bookworm
//
//  Created by Martí Espinosa Farran on 24/7/24.
//

import SwiftData
import SwiftUI

struct ContentView: View {
    @Environment(\.modelContext) var modelContext
    
    @Query(sort: \ReadBook.date, order: .reverse) var books: [ReadBook]
    
    @State private var showingAddScreen = false
    
    @State private var foundBooks: Books?
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(books) { book in
                    NavigationLink(value: book) {
                        HStack {
                            VStack {
                                Text("\(book.date, format: .dateTime.day())")
                                Text("\(book.date, format: .dateTime.month())")
                                    .textCase(.uppercase)
                            }
                            .font(.caption)
                            .padding(4)
                            .background(
                                RoundedRectangle(cornerRadius: 5)
                                    .stroke()
                                    .foregroundStyle(.secondary)
                            )
                            
                            if let thumbnailUrl = URL(string: book.book.volumeInfo.imageLinks?.thumbnail ?? "") {
                                AsyncImage(url: thumbnailUrl) { image in
                                    image
                                        .image?.resizable()
                                        .scaledToFill()
                                }
                                .frame(width: 128 / 5, height: 187 / 5)
                                .clipShape(RoundedRectangle(cornerRadius: 2.5))
                            }
                            
                            VStack(alignment: .leading) {
                                Text(book.book.volumeInfo.title)
                                    .font(.subheadline)
                                    .lineLimit(1)
                                
                                Text(book.book.volumeInfo.authors?.joined(separator: ", ") ?? "")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                                    .lineLimit(1)
                            }
                        }
                    }
                } 
                .onDelete(perform: delete)
            }
            .navigationDestination(for: ReadBook.self) { book in
                DetailBookView(readBook: book)
            }
            .navigationTitle("Bookworm")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    EditButton()
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Add Book", systemImage: "plus.circle.fill") {
                        showingAddScreen.toggle()
                    }
                }
            }
        }
        .sheet(isPresented: $showingAddScreen) {
            AddBookView()
        }
    }
    
    func delete(at offsets: IndexSet) {
        for offset in offsets {
            let book = books[offset]
            modelContext.delete(book)
        }
    }
}

#Preview {
    ContentView()
}
