//
//  Book.swift
//  Bookworm
//
//  Created by Martí Espinosa Farran on 25/7/24.
//

import Foundation
import SwiftData

@Model
class ReadBook {
    var id: UUID
    var review: String
    var rating: Int
    var bookData: Data
    var date: Date
    
    init(book: BookItem, review: String, rating: Int, date: Date) {
        self.id = UUID()
        self.bookData = try! JSONEncoder().encode(book)
        self.review = review
        self.rating = rating
        self.date = date
    }
    
    var book: BookItem {
        get {
            return try! JSONDecoder().decode(BookItem.self, from: bookData)
        }
        set {
            bookData = try! JSONEncoder().encode(newValue)
        }
    }
}
