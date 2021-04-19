//
//  ReviewListView.swift
//  MoviesCoreData
//
//  Created by Dmitry Novosyolov on 19/04/2021.
//

import SwiftUI

struct ReviewListView: View {
    @StateObject
    private var reviewListVM = ReviewListViewModel()
    let movieVM: MovieViewModel
    var body: some View {
        List {
            ForEach(reviewListVM.reviews) { review in
                HStack {
                    VStack(alignment: .leading) {
                        Text(review.title)
                        Text(review.text)
                            .foregroundColor(.secondary)
                    }
                    Spacer()
                    Text(review.publishedAt, style: .date)
                }
            }
        }
        .listStyle(PlainListStyle())
        .navigationTitle("Movie Title")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(
                    action: {
                        reviewListVM.isPresented.toggle()
                    },
                    label: {
                    Text("New Review")
                })
            }
        }
        .sheet(
            isPresented: $reviewListVM.isPresented,
            onDismiss: { reviewListVM.updateUI()}
        ) {
            AddReviewView(movieVM: movieVM)
        }
    }
}

struct ReviewListView_Previews: PreviewProvider {
    static var previews: some View {
        ReviewListView(movieVM: .init(movie: .init(context: CoreDataManager.shared.persistentContainer.viewContext)))
    }
}
