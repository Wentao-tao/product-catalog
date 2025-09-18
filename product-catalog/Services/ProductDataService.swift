//
//  ProductDataService.swift
//  product-catalog
//
//  Created by Wentao Guo on 15/09/25.
//

import Foundation

class ProductDataService {
    static let sampleProducts: [Product] = [
        // iPhone 14 Pro Max
        Product(
            code: "6916323",
            name: "iPhone 14 Pro Max 256GB (Deep Purple)",
            price: 666,
            originalPrice: 720,
            discount: "-5%",
            rating: 4.5,
            reviewCount: 20,
            colors: [
                ProductColor(name: "Deep Purple", colorHex: "#4A4A4A"),
                ProductColor(name: "Purple", colorHex: "#8E5EBF"),
                ProductColor(name: "Gold", colorHex: "#F9E79F"),
                ProductColor(name: "Silver", colorHex: "#C0C0C0")
            ],
            imageName: "iphone14promax",
            brand: "Apple",
            category: "Smartphone",
            location: "London",
            condition: .new,
            storage: "256GB"
        ),
        
        // iPhone 15 Plus Green
        Product(
            code: "8369263",
            name: "APPLE iPhone 15 Plus 256GB (Green)",
            price: 759,
            originalPrice: 799,
            discount: "-5%",
            rating: 4.7,
            reviewCount: 48,
            colors: [
                ProductColor(name: "Black", colorHex: "#000000"),
                ProductColor(name: "Blue", colorHex: "#4A90E2"),
                ProductColor(name: "Green", colorHex: "#7ED321"),
                ProductColor(name: "Yellow", colorHex: "#F5A623"),
                ProductColor(name: "Pink", colorHex: "#E91E63")
            ],
            imageName: "iphone15plus",
            brand: "Apple",
            category: "Smartphone",
            location: "London",
            condition: .new,
            storage: "256GB"
        ),
        
        // iPhone 11 Black
        Product(
            code: "1094719",
            name: "APPLE iPhone 11 128GB (Black)",
            price: 529,
            originalPrice: nil,
            discount: nil,
            rating: 4.3,
            reviewCount: 463,
            colors: [
                ProductColor(name: "Black", colorHex: "#000000"),
                ProductColor(name: "Red", colorHex: "#FF0000"),
                ProductColor(name: "Purple", colorHex: "#8E5EBF")
            ],
            imageName: "iphone11",
            brand: "Apple",
            category: "Smartphone",
            location: "Manchester",
            condition: .likeNew,
            storage: "128GB"
        ),
        
        // iPhone 13 Midnight
        Product(
            code: "5892582",
            name: "APPLE iPhone 13 256GB (Midnight)",
            price: 569,
            originalPrice: 599,
            discount: "-5%",
            rating: 4.6,
            reviewCount: 252,
            colors: [
                ProductColor(name: "Space Gray", colorHex: "#4A4A4A"),
                ProductColor(name: "Silver", colorHex: "#C0C0C0"),
                ProductColor(name: "Gold", colorHex: "#F9E79F")
            ],
            imageName: "iphone13",
            brand: "Apple",
            category: "Smartphone",
            location: "Edinburgh",
            condition: .new,
            storage: "256GB"
        ),
        
        // Samsung Galaxy S22
        Product(
            code: "7891234",
            name: "Samsung Galaxy S22 Ultra 512GB (Phantom Black)",
            price: 899,
            originalPrice: 1099,
            discount: "-18%",
            rating: 4.4,
            reviewCount: 186,
            colors: [
                ProductColor(name: "Phantom Black", colorHex: "#000000"),
                ProductColor(name: "Phantom White", colorHex: "#FFFFFF"),
                ProductColor(name: "Burgundy", colorHex: "#800020")
            ],
            imageName: "galaxys22",
            brand: "Samsung",
            category: "Smartphone",
            location: "London",
            condition: .new,
            storage: "512GB"
        ),
        
        // Google Pixel 7
        Product(
            code: "2345678",
            name: "Google Pixel 7 Pro 256GB (Snow)",
            price: 649,
            originalPrice: 749,
            discount: "-13%",
            rating: 4.2,
            reviewCount: 94,
            colors: [
                ProductColor(name: "Snow", colorHex: "#FFFFFF"),
                ProductColor(name: "Obsidian", colorHex: "#000000"),
                ProductColor(name: "Hazel", colorHex: "#8B7355")
            ],
            imageName: "pixel7",
            brand: "Google",
            category: "Smartphone",
            location: "Manchester",
            condition: .likeNew,
            storage: "256GB"
        ),
        
        // OnePlus 11
        Product(
            code: "3456789",
            name: "OnePlus 11 5G 256GB (Titan Black)",
            price: 599,
            originalPrice: 699,
            discount: "-14%",
            rating: 4.1,
            reviewCount: 73,
            colors: [
                ProductColor(name: "Titan Black", colorHex: "#2C2C2C"),
                ProductColor(name: "Eternal Green", colorHex: "#355E3B")
            ],
            imageName: "oneplus11",
            brand: "OnePlus",
            category: "Smartphone",
            location: "Edinburgh",
            condition: .new,
            storage: "256GB"
        ),
        
        // Xiaomi 13 Pro
        Product(
            code: "4567890",
            name: "Xiaomi 13 Pro 512GB (Ceramic White)",
            price: 749,
            originalPrice: 899,
            discount: "-17%",
            rating: 4.0,
            reviewCount: 128,
            colors: [
                ProductColor(name: "Ceramic White", colorHex: "#FFFFFF"),
                ProductColor(name: "Ceramic Black", colorHex: "#000000"),
                ProductColor(name: "Flora Green", colorHex: "#228B22")
            ],
            imageName: "xiaomi13pro",
            brand: "Xiaomi",
            category: "Smartphone",
            location: "London",
            condition: .new,
            storage: "512GB"
        ),
        
        // Huawei P50 Pro
        Product(
            code: "5678901",
            name: "Huawei P50 Pro 256GB (Golden Black)",
            price: 459,
            originalPrice: 599,
            discount: "-23%",
            rating: 3.9,
            reviewCount: 67,
            colors: [
                ProductColor(name: "Golden Black", colorHex: "#2F2F2F"),
                ProductColor(name: "Pearl White", colorHex: "#F8F8FF"),
                ProductColor(name: "Cocoa Gold", colorHex: "#B8860B")
            ],
            imageName: "huaweip50",
            brand: "Huawei",
            category: "Smartphone",
            location: "Manchester",
            condition: .good,
            storage: "256GB"
        ),
        
        // Nothing Phone 2
        Product(
            code: "6789012",
            name: "Nothing Phone (2) 512GB (White)",
            price: 579,
            originalPrice: 649,
            discount: "-11%",
            rating: 4.3,
            reviewCount: 89,
            colors: [
                ProductColor(name: "White", colorHex: "#FFFFFF"),
                ProductColor(name: "Dark Gray", colorHex: "#2F2F2F")
            ],
            imageName: "nothingphone2",
            brand: "Nothing",
            category: "Smartphone",
            location: "Edinburgh",
            condition: .new,
            storage: "512GB"
        )
    ]
}