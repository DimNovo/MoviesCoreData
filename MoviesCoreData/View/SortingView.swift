//
//  SortingView.swift
//  MoviesCoreData
//
//  Created by Dmitry Novosyolov on 23/04/2021.
//

import SwiftUI

struct SortingView: View {
    @Environment(\.colorScheme)
    var colorScheme
    @ObservedObject
    var movieListVM: MovieListViewModel
    var body: some View {
        VStack {
            Spacer()
            RoundedRectangle(cornerRadius: 25.0, style: .continuous)
                .fill(colorScheme == .dark ? Color(#colorLiteral(red: 0.191370666, green: 0.1960422695, blue: 0.200694561, alpha: 1)) : .white)
                .frame(height: UIScreen.main.bounds.height / 3)
                .shadow(color: colorScheme == .dark ? .clear :
                            Color.secondary.opacity(0.2), radius: 10, y: -10)
                .overlay(
                    VStack {
                        Spacer()
                        Picker(
                            selection: $movieListVM.sortDirection,
                            label: Text("")
                        ) {
                            ForEach(SortDirection.allCases) {
                                Text("\($0)".capitalized)
                                    .tag($0)
                            }
                        }
                        .padding(.horizontal)
                        Spacer()
                        Picker(
                            selection: $movieListVM.sortOption,
                            label: Text("")
                        ) {
                            ForEach(SortOption.allCases) {
                                Text($0.title)
                                    .tag($0)
                            }
                        }
                        .padding(.horizontal)
                        Spacer()
                        Button(
                            action: {
                                movieListVM.sorting()
                            },
                            label: {
                                Label(
                                    title: { Text("Apply movies sorting")},
                                    icon: { Image(systemName: "arrow.up.arrow.down.circle")})
                                    .font(.title3)
                                    .foregroundColor(.white)
                                    .frame(width: UIScreen.main.bounds.width / 1.1, height: 42)
                                    .background(Color.blue.opacity(0.75))
                                    .mask(RoundedRectangle(cornerRadius: 16.0, style: .continuous))
                                    .shadow(radius: 5)
                            })
                            .buttonStyle(PlainButtonStyle())
                        Spacer()
                    }
                    .pickerStyle(SegmentedPickerStyle())
                )
        }
    }
}

struct SortingView_Previews: PreviewProvider {
    static var previews: some View {
        SortingView(movieListVM: MovieListViewModel())
    }
}
