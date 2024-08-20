//
//  BookRowView.swift
//  Bookworm
//
//  Created by Martí Espinosa Farran on 31/7/24.
//

import SwiftData
import SwiftUI

struct BookRowView: View {
    var bookItem: BookItem
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(bookItem.volumeInfo.title)
                    .fontWeight(.medium)
                Text(bookItem.volumeInfo.authors?.joined(separator: ", ") ?? "Unknown Author")
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
            
            if let thumbnailUrl = URL(string: bookItem.volumeInfo.imageLinks?.thumbnail ?? "") {
                AsyncImage(url: thumbnailUrl) { image in
                    image
                        .image?.resizable()
                        .scaledToFill()
                }
                .frame(width: 128 / 2.5, height: 187 / 2.5)
                .clipShape(RoundedRectangle(cornerRadius: 5))
            }
        }
    }
}

#Preview {
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
    
    return BookRowView(bookItem: book)
        .padding()
}
