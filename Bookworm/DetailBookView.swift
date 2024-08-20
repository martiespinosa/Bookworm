//
//  DetailBook.swift
//  Bookworm
//
//  Created by Martí Espinosa Farran on 28/7/24.
//

import SwiftData
import SwiftUI

struct DetailBookView: View {
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss
    @State private var showingDeleteAlert = false
    
    @State private var isReadMoreEnabled = false
    
    let readBook: ReadBook
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 8) {
                        VStack(alignment: .leading) {
                            Text(readBook.book.volumeInfo.title)
                                .font(.title2)
                                .fontWeight(.semibold)
                            
                            Text(readBook.book.volumeInfo.subtitle ?? "")
                                .font(.title3)
                                .fontWeight(.light)
                        }
                        
                        Text(readBook.book.volumeInfo.authors?.joined(separator: ", ") ?? "")
                            .foregroundStyle(.secondary)
                            .font(.headline)
                        
                        Spacer()
                        
                        HStack {
                            Text(readBook.book.volumeInfo.categories?.joined(separator: ", ") ?? "")
                            Text("·")
                            Text(readBook.book.volumeInfo.publishedDate?.prefix(4) ?? "")
                            if let pageCount = readBook.book.volumeInfo.pageCount {
                                Text("·")
                                Text("\(pageCount) Pages")
                            }
                        }
                        .font(.callout)
                        .foregroundStyle(.secondary)
                    }
                    
                    Spacer()
                    
                    if let thumbnailUrl = URL(string: readBook.book.volumeInfo.imageLinks?.thumbnail ?? "") {
                        AsyncImage(url: thumbnailUrl) { image in
                            image
                                .image?.resizable()
                                .scaledToFill()
                        }
                        .frame(width: 128 * 0.8, height: 187 * 0.8)
                        .clipShape(RoundedRectangle(cornerRadius: 5))
                        .background(
                            RoundedRectangle(cornerRadius: 5)
                                .stroke()
                        )
                    }
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Section("Description") {
                        Text(readBook.book.volumeInfo.description ?? "")
                            .font(.callout)
                            .foregroundStyle(.secondary)
                            .lineLimit(isReadMoreEnabled ? nil : 4)
                            .onTapGesture {
                                withAnimation {
                                    isReadMoreEnabled.toggle()
                                }
                            }
                    }
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Section("Review") {
                        RatingView(rating: .constant(readBook.rating))
                            .allowsHitTesting(false)
                            .padding(.bottom, 4)
                        
                        Text(readBook.review)
                    }
                }
                
            }
            .padding()
        }
        .navigationTitle("Book Detail")
        .navigationBarTitleDisplayMode(.inline)
        .scrollBounceBehavior(.basedOnSize)
        .alert("Do you want to delete this book?", isPresented: $showingDeleteAlert) {
            Button("Delete", role: .destructive, action: deleteBook)
            Button("Cancel", role: .cancel) { }
        }
        .toolbar {
            Button("Delete book", systemImage: "trash") {
                showingDeleteAlert = true
            }
        }
    }
    
    func deleteBook() {
        modelContext.delete(readBook)
        dismiss()
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: ReadBook.self, configurations: config)
    
    let book = BookItem(
        id: "8SpxDwAAQBAJ",
        volumeInfo: VolumeInfo(
            title: "12 reglas para vivir",
            subtitle: "Un antídoto al caos",
            authors: ["Jordan B. Peterson"],
            publishedDate: "2018-10-30",
            description: "¿Cuáles son las reglas esenciales para vivir que todos deberíamos conocer? Regla n.° 1: mantente erguido con los hombros hacia atrás..., como las langostas; regla n.° 8: di la verdad, o por lo menos no mientas; regla n.° 11: no molestes a los niños cuando montan en monopatín; regla n.° 12: cuando te encuentres un gato por la calle, acarícialo. Jordan Peterson, «el pensador más polémico e influyente de nuestro tiempo», según el Spectator, nos propone un apasionante viaje por la historia de las ideas y de la ciencia —desde las tradiciones antiguas a los últimos descubrimientos científicos— para tratar de responder a una pregunta esencial: qué información básica necesitamos para vivir en plenitud. Con humor, amenidad y espíritu divulgativo, Peterson recorre países, tiempos y culturas al mismo tiempo que reflexiona sobre conceptos como la aventura, la disciplina y la responsabilidad. Todo con el fin de desgranar el saber humano en doce hondas y prácticas reglas para la vida que rompen radicalmente con los lugares comunes de la corrección política.",
            pageCount: 751,
            imageLinks: ImageLinks(
                thumbnail: "https://books.google.com/books/content?id=8SpxDwAAQBAJ&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api"
            )
        )
    )
    
    let example = ReadBook(book: book, review: "Test review", rating: 4, date: Date.now)
    
    return DetailBookView(readBook: example)
        .modelContainer(container)
}
