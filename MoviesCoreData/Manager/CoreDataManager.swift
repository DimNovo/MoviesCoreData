//
//  CoreDataManager.swift
//  MoviesCoreData
//
//  Created by Dmitry Novosyolov on 17/04/2021.
//

import CoreData
import Combine

final class CoreDataManager {
    
    static let shared = CoreDataManager()
    let persistentContainer: NSPersistentContainer
    
    private init() {
        persistentContainer = .init(name: "MovieDataModel")
        persistentContainer.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Failed to Initialize Core Data \(error.localizedDescription)")
            }
        }
    }
    
    func getMovieById(_ id: NSManagedObjectID) -> Movie? {
        do {
            return
                try persistentContainer.viewContext.existingObject(with: id) as? Movie 
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
    func getAllMovies() -> Future<[Movie], Error> {
        Future { [self] promise in
            let fetchRequest: NSFetchRequest<Movie> = Movie.fetchRequest()
            do {
                let movies = try persistentContainer.viewContext.fetch(fetchRequest)
                promise(.success(movies))
            } catch {
                promise(.failure(error))
            }
        }
    }
    
    func saveMovie(title: String, director: String, rating: Int?, releaseDate: Date) -> Future<Void, Error> {
        Future { [self] promise in
            let movie: Movie = .init(context: persistentContainer.viewContext)
            movie.title = title
            movie.director = director
            movie.rating = Double(rating ?? 0)
            movie.releaseDate = releaseDate
            do {
                try persistentContainer.viewContext.save()
                promise(.success(()))
            } catch {
                promise(.failure(error))
            }
        }
    }
    
    func deleteMovie(_ movie: Movie) -> Future<Void, Error> {
        Future { [self] promise in
            persistentContainer.viewContext.delete(movie)
            do {
                try persistentContainer.viewContext.save()
                promise(.success(()))
            } catch {
                promise(.failure(error))
            }
        }
    }
}

