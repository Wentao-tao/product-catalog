//
//  FilterSheetView.swift
//  product-catalog
//
//  Created by Wentao Guo on 15/09/25.
//

import SwiftUI

struct FilterSheetView: View {
    @ObservedObject var viewModel: ProductCatalogViewModel
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    // Location filter
                    FilterSectionView(title: "Location") {
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 8) {
                            ForEach(viewModel.availableLocations, id: \.self) { location in
                                FilterTagView(
                                    title: location,
                                    count: getLocationCount(location),
                                    isSelected: viewModel.filterState.selectedLocations.contains(location)
                                ) {
                                    viewModel.toggleLocation(location)
                                }
                            }
                        }
                    }
                    
                    // Brand filter
                    FilterSectionView(title: "Maker") {
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 8) {
                            ForEach(viewModel.availableBrands, id: \.self) { brand in
                                FilterTagView(
                                    title: brand,
                                    count: getBrandCount(brand),
                                    isSelected: viewModel.filterState.selectedBrands.contains(brand)
                                ) {
                                    viewModel.toggleBrand(brand)
                                }
                            }
                        }
                    }
                    
                    // Minimum order price range
                    FilterSectionView(title: "Min order") {
                        PriceRangeSlider(
                            minValue: $viewModel.filterState.minPrice,
                            maxValue: $viewModel.filterState.maxPrice,
                            range: 0...2000
                        )
                    }
                    
                    // Condition filter
                    FilterSectionView(title: "Condition") {
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 8) {
                            ForEach(ProductCondition.allCases, id: \.self) { condition in
                                FilterTagView(
                                    title: condition.displayName,
                                    count: getConditionCount(condition),
                                    isSelected: viewModel.filterState.selectedConditions.contains(condition)
                                ) {
                                    viewModel.toggleCondition(condition)
                                }
                            }
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("Filter")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Clear all") {
                        viewModel.clearFilters()
                    }
                    .foregroundColor(.red)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .fontWeight(.semibold)
                }
            }
        }
    }
    
    // MARK: - Helper Methods
    private func getLocationCount(_ location: String) -> Int {
        ProductDataService.sampleProducts.filter { $0.location == location }.count
    }
    
    private func getBrandCount(_ brand: String) -> Int {
        ProductDataService.sampleProducts.filter { $0.brand == brand }.count
    }
    
    private func getConditionCount(_ condition: ProductCondition) -> Int {
        ProductDataService.sampleProducts.filter { $0.condition == condition }.count
    }
}

struct FilterSectionView<Content: View>: View {
    let title: String
    let content: Content
    
    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.headline)
                .fontWeight(.semibold)
            
            content
        }
    }
}

struct FilterTagView: View {
    let title: String
    let count: Int
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(isSelected ? .white : .primary)
                    
                    Text("(\(count))")
                        .font(.caption)
                        .foregroundColor(isSelected ? .white.opacity(0.8) : .gray)
                }
                Spacer()
                
                if isSelected {
                    Image(systemName: "checkmark")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(.white)
                }
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 10)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(isSelected ? Color.green : Color.gray.opacity(0.1))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(isSelected ? Color.green : Color.gray.opacity(0.3), lineWidth: 1)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct PriceRangeSlider: View {
    @Binding var minValue: Double
    @Binding var maxValue: Double
    let range: ClosedRange<Double>
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("\(Int(minValue))$")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.green)
                
                Spacer()
                
                Text("\(Int(maxValue))$")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.green)
            }
            
            // Using simplified slider implementation here
            HStack {
                Slider(value: $minValue, in: range.lowerBound...maxValue)
                    .accentColor(.green)
                
                Slider(value: $maxValue, in: minValue...range.upperBound)
                    .accentColor(.green)
            }
            
            // Preset price range buttons
            HStack(spacing: 8) {
                PriceRangeButton(title: "112$", minValue: $minValue, maxValue: $maxValue, min: 112, max: 200)
                PriceRangeButton(title: "920$", minValue: $minValue, maxValue: $maxValue, min: 920, max: 1200)
                PriceRangeButton(title: "1860$", minValue: $minValue, maxValue: $maxValue, min: 1860, max: 2000)
            }
        }
    }
}

struct PriceRangeButton: View {
    let title: String
    @Binding var minValue: Double
    @Binding var maxValue: Double
    let min: Double
    let max: Double
    
    var body: some View {
        Button {
            minValue = min
            maxValue = max
        } label: {
            Text(title)
                .font(.caption)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(Color.gray.opacity(0.1))
                .cornerRadius(16)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    FilterSheetView(viewModel: ProductCatalogViewModel())
}