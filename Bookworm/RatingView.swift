//
//  RatingView.swift
//  Bookworm
//
//  Created by Martí Espinosa Farran on 25/7/24.
//

import SwiftUI

struct RatingView: View {
    @Binding var rating: Int
    
    var maximumRating = 5
    
    var offImage = Image(systemName: "star")
    var onImage = Image(systemName: "star.fill")
    
    var color = Color.accentColor
    
    var body: some View {
        HStack {            
            HStack {
                ForEach(1...maximumRating, id: \.self) { number in
                    Button {
                        rating = number
                    } label: {
                        image(for: number)
                            .font(.title2)
                            .foregroundStyle(color)
                    }
                }
            }
        }
        .buttonStyle(.plain)
    }
    
    func image(for number: Int) -> Image {
        if number > rating {
            offImage
        } else {
            onImage
        }
    }
}

#Preview {
    RatingView(rating: .constant(4))
}
