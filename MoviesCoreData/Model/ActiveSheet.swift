//
//  ActiveSheet.swift
//  MoviesCoreData
//
//  Created by Dmitry Novosyolov on 22/04/2021.
//

import SwiftUI

enum ActiveSheet: Identifiable, Equatable {
    var id: String { UUID().uuidString }
    case add, filter
}
