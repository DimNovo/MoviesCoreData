//
//  Publisher+Extension.swift
//  MoviesCoreData
//
//  Created by Dmitry Novosyolov on 19/04/2021.
//

import CoreData
import Combine

extension Publisher {
    static func save(
        _ provider: CoreDataProvider = .shared
    ) -> AnyPublisher<Void, Error> {
        Future { promise in
            let context = provider.persistentContainer.viewContext
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
    static func delete<T: NSManagedObject>(
        _ object: T?,
        _ provider: CoreDataProvider = .shared
    ) -> AnyPublisher<Void, Error> {
        Future { promise in
            let context = provider.persistentContainer.viewContext
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
    static func getBy<T: NSManagedObject>(
        _ id: NSManagedObjectID,
        _ provider: CoreDataProvider = .shared
    ) -> AnyPublisher<T?, Error> {
        Future { promise in
            do {
                let context = provider.persistentContainer.viewContext
                promise(.success(try context.existingObject(with: id) as? T))
            } catch {
                promise(.failure(error))
            }
        }
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }
    static func getBy<T: NSManagedObject>(
        _ name: String,
        _ entityName: String,
        _ predicateFormat: String,
        _ provider: CoreDataProvider = .shared
    ) -> AnyPublisher<[T]?, Error> {
        Future { promise in
            do {
                let context = provider.persistentContainer.viewContext
                let request: NSFetchRequest<T> = .init(entityName: entityName)
                request.predicate = NSPredicate(format: predicateFormat, name)
                let array: Array<T> = try context.fetch(request)
                promise(.success(array))
            } catch {
                promise(.failure(error))
            }
        }
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }
    static func getBy<T: NSManagedObject>(
        _ title: String,
        _ entityName: String,
        _ provider: CoreDataProvider = .shared
    ) -> AnyPublisher<[T]?, Error> {
        Future { promise in
            do {
                let context = provider.persistentContainer.viewContext
                let request: NSFetchRequest<T> = .init(entityName: entityName)
                request.predicate =
                    NSPredicate(
                        format: "%K BEGINSWITH[cd] %@",
                        #keyPath(Movie.title),
                        title
                    )
                let array: Array<T> = try context.fetch(request)
                promise(.success(array))
            } catch {
                promise(.failure(error))
            }
        }
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }
    static func getBy<T: NSManagedObject>(
        _ releaseDate: Date,
        _ entityName: String,
        _ provider: CoreDataProvider = .shared
    ) -> AnyPublisher<[T]?, Error> {
        Future { promise in
            do {
                let context = provider.persistentContainer.viewContext
                let request: NSFetchRequest<T> = .init(entityName: entityName)
                request.predicate =
                    NSPredicate(
                        format: "%K == %@",
                        #keyPath(Movie.releaseDate),
                        releaseDate as NSDate
                    )
                let array: Array<T> = try context.fetch(request)
                promise(.success(array))
            } catch {
                promise(.failure(error))
            }
        }
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }
    static func getBy<T: NSManagedObject>(
        _ lowerDate: Date,
        _ upperDate: Date,
        _ minimumRate: Int?,
        _ entityName: String,
        _ provider: CoreDataProvider = .shared
    ) -> AnyPublisher<[T]?, Error> {
        Future { promise in
            do {
                let context = provider.persistentContainer.viewContext
                let request: NSFetchRequest<T> = .init(entityName: entityName)
                var predicates: [NSPredicate] = []
                let dateRangePredicate =
                    NSPredicate(
                        format: "%K >= %@ AND %K <= %@",
                        #keyPath(Movie.releaseDate),
                        lowerDate as NSDate,
                        #keyPath(Movie.releaseDate),
                        upperDate as NSDate
                    )
                predicates.append(dateRangePredicate)
                if let minRate = minimumRate {
                    let ratePredicate =
                        NSPredicate(
                            format: "%K >= %i",
                            #keyPath(Movie.rating),
                            minRate
                        )
                    predicates.append(ratePredicate)
                }
                request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
                let array: Array<T> = try context.fetch(request)
                promise(.success(array))
            } catch {
                promise(.failure(error))
            }
        }
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }
}

extension Publisher {
    static func getAll<T: NSManagedObject>(
        _ provider: CoreDataProvider = .shared
    ) -> AnyPublisher<[T], Error> {
        Future { promise in
            do {
                let context = provider.persistentContainer.viewContext
                let fetchRequest: NSFetchRequest<T> = .init(entityName: String(describing: T.self))
                promise(.success(try context.fetch(fetchRequest)))
            } catch {
                promise(.failure(error))
            }
        }
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }
}
