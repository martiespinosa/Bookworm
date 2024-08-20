//
//  Books.swift
//  Bookworm
//
//  Created by Martí Espinosa Farran on 1/8/24.
//

import Foundation

struct VolumeInfo: Codable, Hashable {
    var title: String
    var subtitle: String?
    var authors: [String]?
    var publishedDate: String?
    var description: String?
    var pageCount: Int?
    var categories: [String]?
    var imageLinks: ImageLinks?
}

struct ImageLinks: Codable, Hashable {
    var thumbnail: String?
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let rawThumbnail = try container.decodeIfPresent(String.self, forKey: .thumbnail)
        self.thumbnail = rawThumbnail?.replacingOccurrences(of: "http://", with: "https://")
    }
    
    // Just for preview purposes
    init(thumbnail: String?) {
        self.thumbnail = thumbnail
    }
}

struct BookItem: Identifiable, Codable, Hashable {
    var id: String
    var volumeInfo: VolumeInfo
}

struct Books: Codable {
    var items: [BookItem]
}
