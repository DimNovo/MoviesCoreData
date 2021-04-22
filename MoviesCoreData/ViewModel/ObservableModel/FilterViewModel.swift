//
//  FilterViewModel.swift
//  MoviesCoreData
//
//  Created by Dmitry Novosyolov on 22/04/2021.
//

import Combine
import SwiftUI

final class FilterViewModel: ObservableObject {
    
    @Published
    var releaseDate = Date()
    @Published
    var lowerBoundDate = Date(timeIntervalSince1970: 3600 * 59550)
    @Published
    var upperBoundDate = Date()
    @Published
    var isRating = false {
        didSet {
            rating = isRating && rating == nil ? 1 : nil
        }
    }
    @Published
    var rating: Int? = nil
    @Published
    var movieTitle = ""
    @Published
    var actorName = ""
    
    @Published
    var flag = false
    
    private typealias MoviesPublisher = AnyPublisher<[Movie], Error>
    private var cancellableSet: Set<AnyCancellable> = []
    
    func filterByTitle(_ movies: Binding<[MovieViewModel]>) {
        MoviesPublisher
            .getBy(movieTitle, "Movie")
            .sink { [self] completion in
                switch completion {
                case .finished:
                    flag.toggle()
                case .failure(let error):
                    print(error.localizedDescription)
                }
            } receiveValue: {
                guard let filteredMovies = $0 as? [Movie] else { return }
                movies.wrappedValue = filteredMovies.map(MovieViewModel.init)
            }
            .store(in: &cancellableSet)
    }
    
    func filterByDate(_ byReleaseDate: Bool, _ movies: Binding<[MovieViewModel]>) {
        switch byReleaseDate {
        case true:
            MoviesPublisher
                .getBy(releaseDate, "Movie")
                .sink { [self] completion in
                    switch completion {
                    case .finished:
                        flag.toggle()
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                } receiveValue: {
                    guard let filteredMovies = $0 as? [Movie] else { return }
                    movies.wrappedValue = filteredMovies.map(MovieViewModel.init)
                }
                .store(in: &cancellableSet)
        case false:
            MoviesPublisher
                .getBy(lowerBoundDate, upperBoundDate, rating, "Movie")
                .sink { [self] completion in
                    switch completion {
                    case .finished:
                        flag.toggle()
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                } receiveValue: {
                    guard let filteredMovies = $0 as? [Movie] else { return }
                    movies.wrappedValue = filteredMovies.map(MovieViewModel.init)
                }
                .store(in: &cancellableSet)
        }
    }
}
