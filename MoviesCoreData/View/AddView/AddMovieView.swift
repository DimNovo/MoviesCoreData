//
//  AddMovieView.swift
//  MoviesCoreData
//
//  Created by Dmitry Novosyolov on 17/04/2021.
//

import SwiftUI

struct AddMovieView: View {
    @Environment(\.presentationMode)
    var presentationMode
    @StateObject
    private var addMovieVM = AddMovieViewModel()
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                Form {
                    Section(header: Text("Movie name & director")) {
                        TextField("enter name", text: $addMovieVM.title)
                        TextField("enter director", text: $addMovieVM.director)
                    }
                    Section(header: Text("Rating")) {
                        RatingView(rating: $addMovieVM.rating, font: .title3)
                            .opacity(addMovieVM.title.isEmpty ||
                                        addMovieVM.director.isEmpty ? 0.35 : 1.0)
                    }
                    .disabled(addMovieVM.title.isEmpty || addMovieVM.director.isEmpty)
                    Section(header: Text("RELEASE DATE")) {
                        DatePicker("", selection: $addMovieVM.releaseDate,
                            in: ...Date(),
                            displayedComponents: .date
                        )
                        .datePickerStyle(GraphicalDatePickerStyle())
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(
                        action: {
                            addMovieVM.save()
                            presentationMode.wrappedValue.dismiss()
                        },
                        label: {
                            Text("Save")
                                .background(
                                    addMovieVM.title.isEmpty ||
                                        addMovieVM.director.isEmpty ?
                                        Color.secondary.opacity(0.35) : nil)
                        })
                        .disabled(
                            addMovieVM.title.isEmpty || addMovieVM.director.isEmpty)
                }
            }
            .navigationBarTitle("Add Movie", displayMode: .inline)
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct AddMovieView_Previews: PreviewProvider {
    static var previews: some View {
        AddMovieView()
    }
}
