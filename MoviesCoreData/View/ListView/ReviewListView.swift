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
            Section(header: Text("Reviews").fontWeight(.light)) {
                ForEach(reviewListVM.reviews) { review in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(review.title)
                                .font(.footnote)
                            Text(review.text)
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        Spacer()
                        Text(review.publishedAt ?? .init(), style: .date)
                            .font(.caption2)
                    }
                }
                .onDelete(perform: { indexSet in
                    reviewListVM.delete(indexSet)
                })
                .listRowBackground(Color.init(.secondarySystemBackground))
            }
        }
        .onAppear { reviewListVM.updateUI(for: movieVM)}
        .listStyle(PlainListStyle())
        .navigationTitle("Reviews")
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
            onDismiss: { reviewListVM.updateUI(for: movieVM)}
        ) {
            AddReviewView(movieVM: movieVM)
        }
    }
}

struct ReviewListView_Previews: PreviewProvider {
    static var previews: some View {
        ReviewListView(
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
