//
//  AddReviewView.swift
//  MoviesCoreData
//
//  Created by Dmitry Novosyolov on 19/04/2021.
//

import SwiftUI

struct AddReviewView: View {
    @Environment(\.presentationMode)
    var presentationMode
    @StateObject
    private var addReviewVM = AddReviewViewModel()
    let movieVM: MovieViewModel
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Review")) {
                    TextField("title", text: $addReviewVM.title)
                    TextField("text", text: $addReviewVM.text)
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(
                        action: {
                            addReviewVM.addReviewForMovie(movieVM)
                            presentationMode.wrappedValue.dismiss()
                        },
                        label: {
                            Text("Save")
                                .background(
                                    addReviewVM.title.isEmpty ||
                                        addReviewVM.text.isEmpty ?
                                        Color.secondary.opacity(0.35) : nil)
                        })
                        .disabled(
                            addReviewVM.title.isEmpty ||
                                addReviewVM.text.isEmpty)
                }
            }
            .navigationBarTitle("Add Review")
        }
    }
}

struct AddReviewView_Previews: PreviewProvider {
    static var previews: some View {
        let context = CoreDataProvider.shared.persistentContainer.viewContext
        AddReviewView(movieVM: .init(movie: .init(context: context)))
    }
}
