//
//  MovieListView.swift
//  MoviesCoreData
//
//  Created by Dmitry Novosyolov on 17/04/2021.
//

import SwiftUI

struct MovieListView: View {
    @ObservedObject
    var movieListVM: MovieListViewModel
    var body: some View {
        if movieListVM.movies.isEmpty {
            Image(systemName: "tray.and.arrow.down")
                .resizable()
                .frame(width: 100, height: 100, alignment: .center)
                .foregroundColor(.init(.secondarySystemBackground))
        } else {
            List {
                Section(header: Text("Movies in alphabet order").fontWeight(.light)) {
                    ForEach(movieListVM.movies.sorted(by: { $0.title < $1.title })) { movieVM in
                        NavigationLink(
                            destination: MovieDetailView(movieVM: movieVM),
                            label: {
                                MovieCellView(movie: movieVM)
                            })
                    }
                    .onDelete(perform: { indexSet in
                        movieListVM.delete(indexSet)
                    })
                    .listRowBackground(Color.init(.secondarySystemBackground))
                }
            }
            .listStyle(PlainListStyle())
        }
    }
}

struct MovieListView_Previews: PreviewProvider {
    static var previews: some View {
        MovieListView(movieListVM: MovieListViewModel())
    }
}
