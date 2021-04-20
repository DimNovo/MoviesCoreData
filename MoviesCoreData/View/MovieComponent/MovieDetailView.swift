//
//  MovieDetailView.swift
//  MoviesCoreData
//
//  Created by Dmitry Novosyolov on 20/04/2021.
//

import SwiftUI

struct MovieDetailView: View {
    let movieVM: MovieViewModel
    var body: some View {
        List {
            Section(header: Text("reviews & actors").fontWeight(.light)) {
                NavigationLink(
                    destination: ReviewListView(movieVM: movieVM),
                    label: {
                        Text("Reviews")
                            .font(.title3)
                            .fontWeight(.medium)
                    })
                    .listRowBackground(Color.blue.opacity(0.25))
                NavigationLink(
                    destination: ActorListView(movieVM: movieVM),
                    label: {
                        Text("Actors")
                            .font(.title3)
                            .fontWeight(.medium)
                    })
                    .listRowBackground(Color.pink.opacity(0.25))
            }
        }
        .navigationTitle(movieVM.title)
    }
}

struct MovieDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let context = CoreDataProvider.shared.persistentContainer.viewContext
        MovieDetailView(movieVM: .init(movie: .init(context: context)))
    }
}
