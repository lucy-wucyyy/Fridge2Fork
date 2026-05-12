//
//  FridgeItem.swift
//  Fridge2Fork
//
//  Created by Shirley Ma on 4/4/25.
//

import Foundation

struct FridgeItem: Identifiable, Equatable {
    let id = UUID()
    var name: String
    var category: String
}
