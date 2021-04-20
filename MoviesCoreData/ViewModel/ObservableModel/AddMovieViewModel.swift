//
//  AddMovieViewModel.swift
//  MoviesCoreData
//
//  Created by Dmitry Novosyolov on 17/04/2021.
//

import Combine
import Foundation

final class AddMovieViewModel: ObservableObject {
    
    @Published
    var flag = false
    @Published
    var rating: Int? = nil
    @Published
    var title = ""
    @Published
    var director = ""
    
    private typealias MoviePublisher = AnyPublisher<Movie, Error>
    var releaseDate = Date()
    private var cancellableSet: Set<AnyCancellable> = []
    
    func save() {
        
        let movie: Movie =
            .init(context: CoreDataProvider.shared.persistentContainer.viewContext)
        movie.title = title
        movie.director = director
        movie.rating = Double(rating ?? 0)
        movie.releaseDate = releaseDate
        
        MoviePublisher
            .save()
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
