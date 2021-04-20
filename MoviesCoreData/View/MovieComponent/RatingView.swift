//
//  RatingView.swift
//  MoviesCoreData
//
//  Created by Dmitry Novosyolov on 17/04/2021.
//

import SwiftUI

struct RatingView: View {
    @Binding
    var rating: Int?
    var font: Font
    var body: some View {
        HStack {
            ForEach(1..<6) { index in
                Image(systemName: starType(index))
                    .font(font)
                    .foregroundColor(.orange)
                    .onTapGesture { rating = index }
            }
        }
    }
}

struct RatingView_Previews: PreviewProvider {
    static var previews: some View {
        RatingView(rating: .constant(4), font: .headline)
            .previewLayout(.sizeThatFits)
    }
}

extension RatingView {
    private func starType(_ index: Int) -> String {
        rating != nil ? (index <= rating ?? index ? "star.fill" : "star") : "star"
    }
}
