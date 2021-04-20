//
//  ActorListView.swift
//  MoviesCoreData
//
//  Created by Dmitry Novosyolov on 20/04/2021.
//

import SwiftUI

struct ActorListView: View {
    @StateObject
    private var actorListVM = ActorListViewModel()
    let movieVM: MovieViewModel
    var body: some View {
        List {
            Section(header: Text("Actors in alphabet order").fontWeight(.light)) {
                ForEach(actorListVM.actors.sorted(by: { $0.name < $1.name })) { actor in
                    NavigationLink(
                        destination: ActorDetailView(actorListVM: actorListVM, actorVM: actor),
                        label: {
                            Text(actor.name)
                        })
                }
                .onDelete(perform: { indexSet in
                    actorListVM.delete(indexSet)
                })
                .listRowBackground(Color.init(.secondarySystemBackground))
            }
        }
        .onAppear { actorListVM.updateUI(for: movieVM)}
        .listStyle(PlainListStyle())
        .navigationTitle("Actors")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(
                    action: {
                        actorListVM.isPresented.toggle()
                    },
                    label: {
                        Text("Add Actor")
                    })
            }
        }
        .sheet(
            isPresented: $actorListVM.isPresented,
            onDismiss: { actorListVM.updateUI(for: movieVM)}
        ) {
            AddActorView(movieVM: movieVM)
        }
    }
}

struct ActorListView_Previews: PreviewProvider {
    static var previews: some View {
        ActorListView(
            movieVM:
                .init(
                    movie:
                        .init(
                            context: CoreDataProvider.shared.persistentContainer.viewContext
                        )
                )
        )
    }
}
