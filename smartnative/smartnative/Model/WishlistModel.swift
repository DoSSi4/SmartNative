//
//  WishlistModel.swift
//  smartnative
//
//  Created by DoSSi4 on 22.06.2021.
//

import Foundation
struct WishlistElement: Codable{
    let id: Int
    let item_id: Int
    let item: Item2
}
struct Item2: Codable {
    let id, count: Int
    let discount, views, price: Int
    let purchases: Int
    let product: Product2
    enum CodingKeys: String, CodingKey{
        case id
        case count, discount, views, price, purchases
        case product
    }
}
struct Product2: Codable{
    let id: Int
    let title: String
    let galleries: [Gallery2]
    enum CodingKeys: String, CodingKey{
        case id
        case title
        case galleries
    }
}
struct Gallery2: Codable {
    let id: Int
    let image: String
    let productID, userID: Int
    enum CodingKeys: String, CodingKey{
        case id, image
        case productID = "product_id"
        case userID = "user_id"
    }
}

