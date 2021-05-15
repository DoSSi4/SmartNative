//
//  Item.swift
//  smartnative
//
//  Created by DoSSi4 on 10.05.2021.
//

import Foundation
struct Item: Codable{
    let id: Int
    let product_id: Int
    let price: Int
    let product: Product
    
}
struct Product: Codable{
    let id: Int
    let galleries: [Galleries]
    let category_id: Int
    let title: String
}
struct Galleries: Codable{
    let product_id: Int
    let id: Int
    let image: String
}
