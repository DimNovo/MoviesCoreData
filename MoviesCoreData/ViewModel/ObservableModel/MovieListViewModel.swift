//
//  MovieListViewModel.swift
//  MoviesCoreData
//
//  Created by Dmitry Novosyolov on 17/04/2021.
//

import Combine
import Foundation

final class MovieListViewModel: ObservableObject {
    
    @Published
    var movies: [MovieViewModel] = []
    @Published
    var activeSheet: ActiveSheet? = nil
    @Published
    var flag = false
    
    @Published
    var isPresented = false
    @Published
    var sortDirection: SortDirection = .ascending
    @Published
    var sortOption: SortOption = .title
    
    private typealias MoviePublisher = AnyPublisher<Movie, Error>
    private typealias MoviesPublisher = AnyPublisher<[Movie], Error>
    private var cancellableSet: Set<AnyCancellable> = []
    
    init() {
        updateUI()
    }
    
    func updateUI() {
        MoviesPublisher
            .getAll()
            .sink { [self] completion in
                switch completion {
                case .finished:
                    sortDirection = .ascending
                    sortOption = .title
                    flag.toggle()
                case .failure(let error):
                    print(error.localizedDescription)
                }
            } receiveValue: { [self] in
                movies = $0.map(MovieViewModel.init)
            }
            .store(in: &cancellableSet)
    }
    
    func delete(_ indexSet: IndexSet) {
        MoviePublisher
            .getBy(indexSet.map { movies[$0].id }[0])
            .flatMap { movie -> AnyPublisher<Void, Error> in
                MoviePublisher
                    .delete(movie)
            }
            .sink { [self] completion in
                switch completion {
                case .finished:
                    movies.remove(atOffsets: indexSet)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            } receiveValue: { _ in }
            .store(in: &cancellableSet)
    }
    
    func sorting() {
        MoviesPublisher
            .sort("Movie", sortOption, sortDirection)
            .sink { [self] completion in
                switch completion {
                case .finished:
                    isPresented.toggle()
                case .failure(let error):
                    print(error.localizedDescription)
                }
            } receiveValue: { [self] in
                if let sortedObjects = $0 as? [Movie] {
                    movies = sortedObjects.map(MovieViewModel.init)
                }
            }
            .store(in: &cancellableSet)
    }
}
