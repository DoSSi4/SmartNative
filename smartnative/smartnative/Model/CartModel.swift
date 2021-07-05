//
//  CartModel.swift
//  smartnative
//
//  Created by DoSSi4 on 22.06.2021.
//

import Foundation
struct CartModel:Codable{
    let order: Order
}
struct Order: Codable{
    let id: Int
    let items: [Item3]
    struct Item3: Codable {
        let product_id: Int
        let id, count: Int
            let discount, price: Int
            let purchases: Int
            let afterDiscount, priceAfterFee: Double
            let pivot: Pivot
            let product: Product3

            enum CodingKeys: String, CodingKey {
                case id
                case product_id
                case count, discount, price, purchases
                case afterDiscount, priceAfterFee, pivot, product
            }
    }
}
struct Product3: Codable{
    let id, category_id: Int
    let title, description: String
    let measure: Measure
    let galleries: [Gallery3]
    let category: Category3
    struct Gallery3: Codable{
        let id: Int
        let image: String
    }
}
struct Pivot: Codable{
    let orderID, itemID: Int
        let count: Double
        let id: Int

        enum CodingKeys: String, CodingKey {
            case orderID = "order_id"
            case itemID = "item_id"
            case count, id
        }
}
struct Measure: Codable{
    let id: Int
    let title, code: String
}
struct Category3: Codable {
    let id: Int
    let title: String
}
