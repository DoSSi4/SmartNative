//
//  PopularItemsModel.swift
//  smartnative
//
//  Created by DoSSi4 on 01.06.2021.
//

import Foundation
struct ItemElement: Codable {
    let id, count: Int
    let price: Int
    let product: PopularProduct
}

struct PopularProduct: Codable {
    let id: Int
    let title: String
    let galleries: [Gallery]
    let category: Category

}

// MARK: - Category
struct Category: Codable {
    let id: Int
    let title: String
}

// MARK: - Gallery
struct Gallery: Codable {
    let id: Int
    let image: String
}
