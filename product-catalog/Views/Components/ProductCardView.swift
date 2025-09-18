//
//  ProductCardView.swift
//  product-catalog
//
//  Created by Wentao Guo on 15/09/25.
//

import SwiftUI

struct ProductCardView: View {
    let product: Product
    @State private var isFavorited = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Product image and favorite button
            ZStack(alignment: .topTrailing) {
                // Product image placeholder
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.gray.opacity(0.1))
                    .frame(height: 180)
                    .overlay(
                        // Using SF Symbols as product image placeholder
                        Image(systemName: "iphone")
                            .font(.system(size: 60))
                            .foregroundColor(.gray.opacity(0.5))
                    )
                
                // Favorite button
                Button {
                    isFavorited.toggle()
                } label: {
                    Image(systemName: isFavorited ? "heart.fill" : "heart")
                        .font(.system(size: 20))
                        .foregroundColor(isFavorited ? .red : .gray)
                        .frame(width: 32, height: 32)
                        .background(Color.white)
                        .clipShape(Circle())
                        .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
                }
                .padding(12)
            }
            
            VStack(alignment: .leading, spacing: 8) {
                // Product code
                Text("code: \(product.code)")
                    .font(.caption)
                    .foregroundColor(.gray)
                
                // Product name
                Text(product.name)
                    .font(.system(size: 14, weight: .medium))
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                
                // Rating and review count
                HStack(spacing: 4) {
                    HStack(spacing: 2) {
                        ForEach(0..<5) { index in
                            Image(systemName: "star.fill")
                                .font(.system(size: 10))
                                .foregroundColor(Double(index) < product.rating ? .yellow : .gray.opacity(0.3))
                        }
                    }
                    Text("(\(product.reviewCount) reviews)")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                
                // Color selector
                HStack(spacing: 6) {
                    ForEach(product.colors.prefix(4)) { color in
                        Circle()
                            .fill(Color(hex: color.colorHex))
                            .frame(width: 16, height: 16)
                            .overlay(
                                Circle()
                                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                            )
                    }
                    if product.colors.count > 4 {
                        Text("+\(product.colors.count - 4)")
                            .font(.caption2)
                            .foregroundColor(.gray)
                    }
                }
                
                Spacer()
                
                // Price and discount information
                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        if let originalPrice = product.originalPrice,
                           let discount = product.discount {
                            HStack(spacing: 4) {
                                Text("\(Int(originalPrice))$")
                                    .font(.caption)
                                    .strikethrough()
                                    .foregroundColor(.gray)
                                Text(discount)
                                    .font(.caption)
                                    .foregroundColor(.red)
                                    .padding(.horizontal, 4)
                                    .padding(.vertical, 2)
                                    .background(Color.red.opacity(0.1))
                                    .cornerRadius(4)
                            }
                        }
                        
                        Text("\(Int(product.price))$")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.primary)
                    }
                    
                    Spacer()
                    
                    // Add to cart button
                    Button {
                        // Add to cart logic
                    } label: {
                        Image(systemName: "cart.badge.plus")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(width: 36, height: 36)
                            .background(Color.green)
                            .clipShape(Circle())
                    }
                }
            }
            .padding(.horizontal, 8)
            .padding(.bottom, 12)
        }
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
    }
}

// MARK: - Color Extension
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

#Preview {
    ProductCardView(product: ProductDataService.sampleProducts[0])
        .frame(width: 200)
        .padding()
}