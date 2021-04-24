//
//  FiltersView.swift
//  MoviesCoreData
//
//  Created by Dmitry Novosyolov on 21/04/2021.
//

import SwiftUI

struct FiltersView: View {
    @Environment(\.presentationMode)
    var presentationMode
    @StateObject
    private var filterVM = FilterViewModel()
    @Binding
    var movies: [MovieViewModel]
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("by min reviews count")) {
                    TextField("name...", text: $filterVM.minReviewsCount)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.numberPad)
                    Button(
                        action: {
                            filterVM.filterByReviews($movies)
                            presentationMode.wrappedValue.dismiss()
                        },
                        label: {
                            Label(
                                title: { Text("Apply filter") },
                                icon: { Image(systemName: "line.horizontal.3.decrease.circle") })
                                .font(.title3)
                                .foregroundColor(.white)
                                .frame(width: UIScreen.main.bounds.width / 1.2, height: 42)
                                .background(Color.blue.opacity(0.75))
                                .mask(RoundedRectangle(cornerRadius: 16.0, style: .continuous))
                                .shadow(radius: 5)
                        })
                        .buttonStyle(PlainButtonStyle())
                }
                Section(header: Text("by movie name")) {
                    TextField("name...", text: $filterVM.movieTitle)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    Button(
                        action: {
                            filterVM.filterByTitle($movies)
                            presentationMode.wrappedValue.dismiss()
                        },
                        label: {
                            Label(
                                title: { Text("Apply filter") },
                                icon: { Image(systemName: "line.horizontal.3.decrease.circle") })
                                .font(.title3)
                                .foregroundColor(.white)
                                .frame(width: UIScreen.main.bounds.width / 1.2, height: 42)
                                .background(Color.blue.opacity(0.75))
                                .mask(RoundedRectangle(cornerRadius: 16.0, style: .continuous))
                                .shadow(radius: 5)
                        })
                        .buttonStyle(PlainButtonStyle())
                }
                Section(header: Text("by actor name")) {
                    TextField("name...", text: $filterVM.actorName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    Button(
                        action: {
                            filterVM.filterByActorName($movies)
                            presentationMode.wrappedValue.dismiss()
                        },
                        label: {
                            Label(
                                title: { Text("Apply filter") },
                                icon: { Image(systemName: "line.horizontal.3.decrease.circle") })
                                .font(.title3)
                                .foregroundColor(.white)
                                .frame(width: UIScreen.main.bounds.width / 1.2, height: 42)
                                .background(Color.blue.opacity(0.75))
                                .mask(RoundedRectangle(cornerRadius: 16.0, style: .continuous))
                                .shadow(radius: 5)
                        })
                        .buttonStyle(PlainButtonStyle())
                }
                Section(header: Text("by release date")) {
                    DatePicker(
                        "Date",
                        selection: $filterVM.releaseDate,
                        in: ...Date(),
                        displayedComponents: .date)
                    Button(
                        action: {
                            filterVM.filterByDate(true, $movies)
                            presentationMode.wrappedValue.dismiss()
                        },
                        label: {
                            Label(
                                title: { Text("Apply filter") },
                                icon: { Image(systemName: "line.horizontal.3.decrease.circle") })
                                .font(.title3)
                                .foregroundColor(.white)
                                .frame(width: UIScreen.main.bounds.width / 1.2, height: 42)
                                .background(Color.blue.opacity(0.75))
                                .mask(RoundedRectangle(cornerRadius: 16.0, style: .continuous))
                                .shadow(radius: 5)
                        })
                        .buttonStyle(PlainButtonStyle())
                }
                Section(header: Text("by date range & rating")) {
                    DatePicker(
                        "From\nDate",
                        selection: $filterVM.lowerBoundDate,
                        in: filterVM.lowerBoundDate...filterVM.upperBoundDate,
                        displayedComponents: .date)
                    DatePicker(
                        "Until\nDate",
                        selection: $filterVM.upperBoundDate,
                        in: filterVM.lowerBoundDate...filterVM.upperBoundDate,
                        displayedComponents: .date)
                    Toggle(isOn: $filterVM.isRating, label: {
                        RatingView(rating: $filterVM.rating, font: .callout)
                            .opacity(!filterVM.isRating ? 0.25 : 1.0)
                            .disabled(!filterVM.isRating)
                    })
                    Button(
                        action: {
                            filterVM.filterByDate(false, $movies)
                            presentationMode.wrappedValue.dismiss()
                        },
                        label: {
                            Label(
                                title: { Text("Apply filter") },
                                icon: { Image(systemName: "line.horizontal.3.decrease.circle") })
                                .font(.title3)
                                .foregroundColor(.white)
                                .frame(width: UIScreen.main.bounds.width / 1.2, height: 42)
                                .background(Color.blue.opacity(0.75))
                                .mask(RoundedRectangle(cornerRadius: 16.0, style: .continuous))
                                .shadow(radius: 5)
                        })
                        .buttonStyle(PlainButtonStyle())
                }
            }
            .navigationTitle("Filters")
        }
    }
}

struct FiltersView_Previews: PreviewProvider {
    static var previews: some View {
        FiltersView(movies: .constant(.init()))
    }
}
