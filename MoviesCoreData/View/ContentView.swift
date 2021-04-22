//
//  ContentView.swift
//  MoviesCoreData
//
//  Created by Dmitry Novosyolov on 17/04/2021.
//

import SwiftUI

struct ContentView: View {
    @StateObject
    private var movieListVM = MovieListViewModel()
    var body: some View {
        NavigationView {
            MovieListView(movieListVM: movieListVM)
                .navigationBarItems(
                    leading:
                        HStack(spacing: 20) {
                            Button(
                                action: {
                                    movieListVM.activeSheet = .filter
                                }, label: {
                                    Image(systemName: "line.horizontal.3.decrease.circle")
                                        .font(.title)
                                }
                            )
                            .opacity(movieListVM.movies.isEmpty ? 0.25 : 1.0)
                            .disabled(movieListVM.movies.isEmpty)
                            Button(
                                action: {
                                    movieListVM.updateUI()
                                }, label: {
                                    Image(systemName: "xmark.circle")
                                        .font(.title)
                                        .foregroundColor(.red)
                                }
                            )
                        },
                    trailing:
                        Button(
                            action: {
                                movieListVM.activeSheet = .add
                            }, label: {
                                Text("Add Movie")
                            }
                        ))
                .sheet(item: $movieListVM.activeSheet) { item in
                    switch item {
                    case .add:
                        AddMovieView()
                            .onDisappear {
                                movieListVM.updateUI()
                            }
                    case .filter:
                        FiltersView(movies: $movieListVM.movies)
                    }
                }
                .navigationTitle("Movies")
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
