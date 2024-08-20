//
//  AddBookView.swift
//  Bookworm
//
//  Created by Martí Espinosa Farran on 25/7/24.
//

import SwiftUI

struct AddBookView: View {
    @Environment(\.dismiss) var dismiss
    
    @State private var searchTerm = ""
    
    @State private var foundBooks = Books(items: [])
        
    var body: some View {
        NavigationStack {
            VStack {
                List(foundBooks.items) { book in
                    NavigationLink(destination: BookReviewView(bookItem: book)) {
                        BookRowView(bookItem: book)
                    }
                }
                .listStyle(.plain)
                .searchable(text: $searchTerm, placement: .navigationBarDrawer(displayMode: .always))
                
                Spacer()
            }
            .navigationTitle("Add Book")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundStyle(.primary)
                }
            }
        }
        .onAppear {
            popular()
        }
        .onChange(of: searchTerm, initial: true) { newValue, _ in
            if !newValue.isEmpty {
                found(for: newValue)
            }
        }
    }
    
    func found(for title: String) {
        BookSearchManager().getBooks(searchTerm: searchTerm) { books in
            if let books {
                withAnimation {
                    foundBooks = books
                }
            }
        }
    }
    
    func popular() {
        BookSearchManager().getPopularBooks() { books in
            if let books {
                withAnimation {
                    foundBooks = books
                }
            }
        }
    }
}

#Preview {
    AddBookView()
}
