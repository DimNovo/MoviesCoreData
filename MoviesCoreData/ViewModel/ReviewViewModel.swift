//
//  ReviewViewModel.swift
//  MoviesCoreData
//
//  Created by Dmitry Novosyolov on 19/04/2021.
//

import CoreData
import Foundation

final class ReviewViewModel: Identifiable {
    private let review: Review
    init(review: Review) {
        self.review = review
    }
    var id: NSManagedObjectID {
        review.objectID
    }
    var title: String {
        review.title ?? ""
    }
    var text: String {
        review.text ?? ""
    }
    var publishedAt: Date? {
        review.publishedAt
    }
    var movie: Movie? {
        review.movie
    }
}
