//
//  Sorting.swift
//  MoviesCoreData
//
//  Created by Dmitry Novosyolov on 23/04/2021.
//

import Foundation

enum SortDirection: Identifiable, CaseIterable {
    var id: String { UUID().uuidString }
    case ascending, descending
}

enum SortOption: Identifiable, CaseIterable {
    var id: String { UUID().uuidString }
    case title, releaseDate, rating
    var title: String {
        switch self {
        case .title:
            return "Name"
        case .releaseDate:
            return "Release Date"
        case .rating:
            return "Rating"
        }
    }
}
