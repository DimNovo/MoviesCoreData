//
//  ReviewListViewModel.swift
//  MoviesCoreData
//
//  Created by Dmitry Novosyolov on 19/04/2021.
//

import Combine
import Foundation

final class ReviewListViewModel: ObservableObject {
    
    @Published
    var reviews: [ReviewViewModel] = []
    @Published
    var isPresented = false
    @Published
    var flag = false
    
    private var cancellableSet: Set<AnyCancellable> = []
    
    func updateUI(for movie: MovieViewModel, _ manager: CoreDataManager = .shared) {
        guard let movie = manager.getMovieById(movie.id),
              let currentReviews = movie.reviews?.allObjects as? [Review]
        else { return }
        DispatchQueue.main.async { [self] in
            reviews = currentReviews.map(ReviewViewModel.init)
        }
    }
    
    func delete(_ indexSet: IndexSet, _ manager: CoreDataManager = .shared) {
        
    }
}
