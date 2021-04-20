//
//  CoreDataProvider.swift
//  MoviesCoreData
//
//  Created by Dmitry Novosyolov on 17/04/2021.
//

import CoreData
import Combine

final class CoreDataProvider {
    
    static let shared = CoreDataProvider()
    let persistentContainer: NSPersistentContainer
    
    private init() {
        persistentContainer = .init(name: "MovieDataModel")
        persistentContainer.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Failed to Initialize Core Data \(error.localizedDescription)")
            }
        }
    }
}

