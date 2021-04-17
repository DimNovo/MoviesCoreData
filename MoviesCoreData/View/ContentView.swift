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
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(
                            action: {
                                movieListVM.isPresented.toggle()
                            }, label: {
                                Text("Add Movie")
                            }
                        )
                    }
                }
                .sheet(
                    isPresented: $movieListVM.isPresented,
                    onDismiss: {
                        movieListVM.updateUI()
                    }
                ) {
                    AddMovieView()
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
