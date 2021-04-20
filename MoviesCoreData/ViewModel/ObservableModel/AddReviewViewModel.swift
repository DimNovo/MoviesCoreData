//
//  AddReviewViewModel.swift
//  MoviesCoreData
//
//  Created by Dmitry Novosyolov on 19/04/2021.
//

import Combine
import Foundation

final class AddReviewViewModel: ObservableObject {
    
    @Published
    var title = ""
    @Published
    var text = ""
    @Published
    var flag = false
    
    private typealias MoviePublisher = AnyPublisher<Movie, Error>
    private var cancellableSet: Set<AnyCancellable> = []
    
    func addReviewForMovie(_ movieVM: MovieViewModel) {
        MoviePublisher
            .getBy(movieVM.id)
            .flatMap { [self] movie -> AnyPublisher<Void, Error> in
                if let movie = movie as? Movie {
                    let review: Review =
                        .init(context: CoreDataProvider.shared.persistentContainer.viewContext)
                    review.title = title
                    review.text = text
                    review.movie = movie
                }
                return
                    MoviePublisher
                    .save()
            }
            .sink { [self] completion in
                switch completion {
                case .finished:
                    flag.toggle()
                case .failure(let error):
                    print(error.localizedDescription)
                }
            } receiveValue: { _ in }
            .store(in: &cancellableSet)
    }
}
