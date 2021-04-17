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
                }
                HStack {
                    Text("RELEASE DATE")
                        .font(.footnote)
                        .fontWeight(.medium)
                        .foregroundColor(.secondary)
                    Spacer()
                }
                .padding([.vertical, .leading])
                .frame(width: UIScreen.main.bounds.width)
                .background(Color.init(.secondarySystemBackground))
                DatePicker(
                    addMovieVM.title.isEmpty ||
                        addMovieVM.director.isEmpty ? "" : "Date",
                    selection: $addMovieVM.releaseDate,
                    in: ...Date(),
                    displayedComponents: .date
                )
                .padding(.horizontal)
                .datePickerStyle(GraphicalDatePickerStyle())
                .disabled(addMovieVM.title.isEmpty || addMovieVM.director.isEmpty)
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
    }
}

struct AddMovieView_Previews: PreviewProvider {
    static var previews: some View {
        AddMovieView()
    }
}
