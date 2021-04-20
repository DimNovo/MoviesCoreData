//
//  AddActorViewModel.swift
//  MoviesCoreData
//
//  Created by Dmitry Novosyolov on 20/04/2021.
//

import Combine
import Foundation

final class AddActorViewModel: ObservableObject {
    
    @Published
    var name = ""
    @Published
    var flag = false
    
    private typealias MoviePublisher = AnyPublisher<Movie, Error>
    private var cancellableSet: Set<AnyCancellable> = []
    
    func addActorToMovie(_ movie: MovieViewModel) {
        MoviePublisher
            .getBy(movie.id)
            .flatMap { [self] movie -> AnyPublisher<Void, Error> in
                if let movie = movie as? Movie {
                    let actor: Actor =
                        .init(context: CoreDataProvider.shared.persistentContainer.viewContext)
                    actor.name = name
                    movie.addToActors(actor)
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
