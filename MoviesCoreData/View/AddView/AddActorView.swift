//
//  AddActorView.swift
//  MoviesCoreData
//
//  Created by Dmitry Novosyolov on 20/04/2021.
//

import SwiftUI

struct AddActorView: View {
    @Environment(\.presentationMode)
    var presentationMode
    @StateObject
    private var addActorVM = AddActorViewModel()
    let movieVM: MovieViewModel
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Actor")) {
                    TextField("name", text: $addActorVM.name)
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(
                        action: {
                            addActorVM.addActorToMovie(movieVM)
                            presentationMode.wrappedValue.dismiss()
                        },
                        label: {
                            Text("Save")
                                .background(
                                    addActorVM.name.isEmpty ?
                                        Color.secondary.opacity(0.35) : nil)
                        })
                        .disabled(addActorVM.name.isEmpty)
                }
            }
            .navigationBarTitle("Add Actor")
        }
    }
}

struct AddActorView_Previews: PreviewProvider {
    static var previews: some View {
        let context = CoreDataProvider.shared.persistentContainer.viewContext
        AddActorView(movieVM: .init(movie: .init(context: context)))
    }
}
