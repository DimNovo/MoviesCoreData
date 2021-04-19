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
    
    private var cancellableSet: Set<AnyCancellable> = []
    
    func addReviewForMovie(
        _ movieVM: MovieViewModel,
        _ manager: CoreDataManager = .shared
    ) {
        
        let movie = manager.getMovieById(movieVM.id)
        let review: Review =
            .init(context: manager.persistentContainer.viewContext)
        review.title = title
        review.text = text
        review.movie = movie
        
        manager.save()
            .receive(on: DispatchQueue.main)
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
