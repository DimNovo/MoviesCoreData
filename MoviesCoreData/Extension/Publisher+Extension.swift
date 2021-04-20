//
//  Publisher+Extension.swift
//  MoviesCoreData
//
//  Created by Dmitry Novosyolov on 19/04/2021.
//

import CoreData
import Combine

extension Publisher {
    static func save() -> AnyPublisher<Void, Error> {
        Future { promise in
            let context = CoreDataProvider.shared.persistentContainer.viewContext
            do {
                try context.save()
                promise(.success(()))
            } catch {
                context.rollback()
                promise(.failure(error))
            }
        }
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }
}

extension Publisher {
    static func delete<T: NSManagedObject>(_ object: T?) -> AnyPublisher<Void, Error> {
        Future { promise in
            let context = CoreDataProvider.shared.persistentContainer.viewContext
            do {
                if let object = object {
                    context.delete(object)
                    try context.save()
                    promise(.success(()))
                }
            } catch {
                context.rollback()
                promise(.failure(error))
            }
        }
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }
}

extension Publisher {
    static func getMoviesByActor(
        _ name: String,
        _ predicateFormat: String
    ) -> AnyPublisher<[Movie]?, Error> {
        Future { promise in
            do {
                let context = CoreDataProvider.shared.persistentContainer.viewContext
                let request: NSFetchRequest = Movie.fetchRequest()
                request.predicate = NSPredicate(format: predicateFormat, name)
                promise(.success(try context.fetch(request)))
            } catch {
                promise(.failure(error))
            }
        }
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }
}

extension Publisher {
    static func getBy<T: NSManagedObject>(_ id: NSManagedObjectID) -> AnyPublisher<T?, Error> {
        Future { promise in
            let context = CoreDataProvider.shared.persistentContainer.viewContext
            do {
                promise(.success(try context.existingObject(with: id) as? T))
            } catch {
                promise(.failure(error))
            }
        }
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }
}

extension Publisher {
    static func getAll<T: NSManagedObject>() -> AnyPublisher<[T], Error> {
        Future { promise in
            let context = CoreDataProvider.shared.persistentContainer.viewContext
            let fetchRequest: NSFetchRequest<T> = .init(entityName: String(describing: T.self))
            do {
                promise(.success(try context.fetch(fetchRequest)))
            } catch {
                promise(.failure(error))
            }
        }
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }
}
