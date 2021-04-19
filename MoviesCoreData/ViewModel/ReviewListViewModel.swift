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
    
    init() {
        updateUI()
    }
    
    func updateUI(_ manager: CoreDataManager = .shared) {
        
    }
    
    func delete(_ indexSet: IndexSet, _ manager: CoreDataManager = .shared) {
        
    }
}
