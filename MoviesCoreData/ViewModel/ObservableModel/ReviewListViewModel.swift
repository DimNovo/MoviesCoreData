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
    
    private typealias MoviePublisher = AnyPublisher<Movie, Error>
    private var cancellableSet: Set<AnyCancellable> = []
    
    func updateUI(for movie: MovieViewModel) {
        MoviePublisher
            .getBy(movie.id)
            .sink { [self] completion in
                switch completion {
                case .finished:
                    flag.toggle()
                case .failure(let error):
                    print(error.localizedDescription)
                }
            } receiveValue: { [self] in
                if let movie = $0 as? Movie,
                   let fetchedReviews = movie.reviews?.allObjects as? [Review] {
                    reviews = fetchedReviews.map(ReviewViewModel.init)
                }
            }
            .store(in: &cancellableSet)
    }
    
    func delete(_ indexSet: IndexSet, _ manager: CoreDataProvider = .shared) {
        guard let reviewVM = indexSet.compactMap({ reviews[$0]}).first else { return }
        MoviePublisher
            .getBy(reviewVM.id)
            .flatMap { review -> AnyPublisher<Void, Error> in
                MoviePublisher
                    .delete(review)
            }
            .sink { [self] completion in
                switch completion {
                case .finished:
                    reviews.remove(atOffsets: indexSet)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            } receiveValue: { _ in }
            .store(in: &cancellableSet)
    }
}
