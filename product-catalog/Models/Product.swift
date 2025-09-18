//
//  Product.swift
//  product-catalog
//
//  Created by Wentao Guo on 15/09/25.
//

import Foundation

// MARK: - Product Model
struct Product: Identifiable, Codable, Equatable {
    let id = UUID()
    let code: String
    let name: String
    let price: Double
    let originalPrice: Double?
    let discount: String?
    let rating: Double
    let reviewCount: Int
    let colors: [ProductColor]
    let imageName: String
    let brand: String
    let category: String
    let location: String
    let condition: ProductCondition
    let storage: String?
    
    var discountedPrice: Double {
        originalPrice ?? price
    }
    
    var hasDiscount: Bool {
        originalPrice != nil && discount != nil
    }
}

// MARK: - Product Color
struct ProductColor: Identifiable, Codable, Equatable {
    let id = UUID()
    let name: String
    let colorHex: String
}

// MARK: - Product Condition
enum ProductCondition: String, CaseIterable, Codable {
    case new = "New"
    case likeNew = "Like New" 
    case good = "Good"
    case fair = "Fair"
    
    var displayName: String {
        return self.rawValue
    }
}

// MARK: - Filter Options
enum SortOption: String, CaseIterable {
    case highestPrice = "Highest Price"
    case lowestPrice = "Lowest Price"
    case rating = "Rating"
    case reviews = "Reviews"
    
    var displayName: String {
        return self.rawValue
    }
}

struct FilterState {
    var selectedLocations: Set<String> = []
    var selectedBrands: Set<String> = []
    var selectedConditions: Set<ProductCondition> = []
    var minPrice: Double = 0
    var maxPrice: Double = 2000
    var sortOption: SortOption = .highestPrice
}