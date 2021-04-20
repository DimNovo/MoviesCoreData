//
//  ActorDetailView.swift
//  MoviesCoreData
//
//  Created by Dmitry Novosyolov on 20/04/2021.
//

import SwiftUI

struct ActorDetailView: View {
    @ObservedObject
    var actorListVM: ActorListViewModel
    let actorVM: ActorViewModel
    var body: some View {
        List {
            Section(header: Text("Movies by actor in alphabet order").fontWeight(.light)) {
                ForEach(actorListVM.movies.sorted(by: { $0.title < $1.title })) {
                    MovieCellView(movie: $0)
                }
            }
        }
        .onAppear { actorListVM.getMoviesByActor(actorVM.name)}
        .listStyle(PlainListStyle())
        .navigationTitle(actorVM.name)
    }
}

struct ActorDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ActorDetailView(
            actorListVM: ActorListViewModel(),
            actorVM:
                .init(
                    actor:
                        .init(
                            context: CoreDataProvider.shared.persistentContainer.viewContext
                        )
                )
        )
    }
}
