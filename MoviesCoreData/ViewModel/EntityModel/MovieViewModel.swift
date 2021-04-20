//
//  MovieViewModel.swift
//  MoviesCoreData
//
//  Created by Dmitry Novosyolov on 17/04/2021.
//

import CoreData
import Foundation

final class MovieViewModel: Identifiable {
    private let movie: Movie
    init(movie: Movie) {
        self.movie = movie
    }
    var id: NSManagedObjectID {
        movie.objectID
    }
    var title: String {
        movie.title ?? ""
    }
    var director: String {
        movie.director ?? ""
    }
    var releaseDate: Date {
        movie.releaseDate ?? .init()
    }
    var rating: Int? {
        Int(movie.rating)
    }
}
