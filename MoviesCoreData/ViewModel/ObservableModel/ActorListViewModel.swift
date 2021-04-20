//
//  ActorListViewModel.swift
//  MoviesCoreData
//
//  Created by Dmitry Novosyolov on 20/04/2021.
//

import Combine
import Foundation

final class ActorListViewModel: ObservableObject {
    
    @Published
    var actors: [ActorViewModel] = []
    @Published
    var movies: [MovieViewModel] = []
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
                   let fetchedActors = movie.actors?.allObjects as? [Actor] {
                    actors = fetchedActors.map(ActorViewModel.init)
                }
            }
            .store(in: &cancellableSet)
    }
    
    func getMoviesByActor(_ name: String) {
        let predicate = "actors.name CONTAINS %@"
        MoviePublisher
            .getMoviesByActor(name, predicate)
            .sink { [self] completion in
                switch completion {
                case .finished:
                    flag.toggle()
                case .failure(let error):
                    print(error.localizedDescription)
                }
            } receiveValue: { [self] in
                if let moviesByActor = $0 {
                    movies = moviesByActor.map(MovieViewModel.init)
                }
            }
            .store(in: &cancellableSet)
    }
    
    func delete(_ indexSet: IndexSet, _ manager: CoreDataProvider = .shared) {
        guard let actor = indexSet.map({ actors[$0]}).first else { return }
        MoviePublisher
            .getBy(actor.id)
            .flatMap { actor -> AnyPublisher<Void, Error> in
                MoviePublisher
                    .delete(actor)
            }
            .sink { [self] completion in
                switch completion {
                case .finished:
                    actors.remove(atOffsets: indexSet)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            } receiveValue: { _ in }
            .store(in: &cancellableSet)
    }
}
