//
//  ActorViewModel.swift
//  MoviesCoreData
//
//  Created by Dmitry Novosyolov on 20/04/2021.
//

import CoreData
import Foundation

final class ActorViewModel: Identifiable {
    private let actor: Actor
    init(actor: Actor) {
        self.actor = actor
    }
    var id: NSManagedObjectID {
        actor.objectID
    }
    var name: String {
        actor.name ?? ""
    }
}
