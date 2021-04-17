//
//  MovieCellView.swift
//  MoviesCoreData
//
//  Created by Dmitry Novosyolov on 17/04/2021.
//

import SwiftUI

struct MovieCellView: View {
    let movie: MovieViewModel
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 5) {
                Text(movie.title)
                    .font(.headline)
                Text(movie.director)
                    .font(.caption2)
                Text(movie.releaseDate, style: .date)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            Spacer()
            RatingView(rating: .constant(movie.rating), font: .subheadline)
        }
    }
}

struct MovieCellView_Previews: PreviewProvider {
    static var previews: some View {
        let manager = CoreDataManager.shared
        let context = manager.persistentContainer.viewContext
        MovieCellView(movie: MovieViewModel(movie: .init(context: context)))
    }
}
