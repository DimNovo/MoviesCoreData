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
    var isPresented = false 
    @Published
    var flag = false
    
    private var cancellableSet: Set<AnyCancellable> = []
    
    init() {
        updateUI()
    }
    
    func updateUI(_ manager: CoreDataManager = .shared) {
        manager
            .getAllMovies()
            .receive(on: DispatchQueue.main)
            .sink { [self] completion in
                switch completion {
                case .finished:
                    flag.toggle()
                case .failure(let error):
                    print(error.localizedDescription)
                }
            } receiveValue: { [self] in
                movies = $0.map(MovieViewModel.init)
            }
            .store(in: &cancellableSet)
    }
    
    func delete(_ indexSet: IndexSet, _ manager: CoreDataManager = .shared) {
        guard let movieVM = indexSet.map({ movies[$0]}).first,
              let movie = manager.getMovieById(movieVM.id) else { return }
        manager
            .deleteMovie(movie)
            .receive(on: DispatchQueue.main)
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
}
