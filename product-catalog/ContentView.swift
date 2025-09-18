//
//  ContentView.swift
//  product-catalog
//
//  Created by Wentao Guo on 15/09/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = ProductCatalogViewModel()
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Top navigation bar
                TopNavigationBar()
                
                // Search bar
                SearchBar(searchText: $viewModel.searchText)
                    .padding(.horizontal)
                    .padding(8)
                
                // Active filters view
                ActiveFiltersView(viewModel: viewModel)
                
                // Product results header
                ProductResultsHeader(viewModel: viewModel)
                
                // Product grid
                ProductGridView(viewModel: viewModel)
            }
            .navigationBarHidden(true)
            .background(Color(.systemGroupedBackground))
        }
        .sheet(isPresented: $viewModel.isFilterSheetPresented) {
            FilterSheetView(viewModel: viewModel)
        }
    }
}

// MARK: - Top Navigation Bar
struct TopNavigationBar: View {
    
    var body: some View {
        HStack {
            // Logo and title
            HStack(spacing: 8) {
                
                
                Text("Catalog")
                    .font(.title2)
                    .fontWeight(.bold)
            }
            
            Spacer()
            
        }
        .padding(.horizontal)
        .padding(.vertical, 12)
        .background(Color.white)
    }
}

// MARK: - Search Bar
struct SearchBar: View {
    @Binding var searchText: String
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
            
            TextField("Search...", text: $searchText)
                .textFieldStyle(PlainTextFieldStyle())
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(Color.white)
        .cornerRadius(8)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
        )
    }
}

// MARK: - Active Filters View
struct ActiveFiltersView: View {
    @ObservedObject var viewModel: ProductCatalogViewModel
    
    var body: some View {
        if hasActiveFilters {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    // Filter button
                    Button {
                        viewModel.isFilterSheetPresented = true
                    } label: {
                        HStack(spacing: 6) {
                            Image(systemName: "slider.horizontal.3")
                            Text("Filter")
                        }
                        .font(.caption)
                        .fontWeight(.medium)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(20)
                    }
                    
                    // Active filter tags
                    ForEach(activeFilterTags, id: \.self) { tag in
                        ActiveFilterTag(title: tag) {
                            removeFilter(tag)
                        }
                    }
                    
                    // Clear all button
                    if !activeFilterTags.isEmpty {
                        Button {
                            viewModel.clearFilters()
                        } label: {
                            Text("Clear all")
                                .font(.caption)
                                .foregroundColor(.red)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 8)
                                .background(Color.red.opacity(0.1))
                                .cornerRadius(20)
                        }
                    }
                }
                .padding(.horizontal)
            }
            .padding(.bottom, 8)
        }
    }
    
    private var hasActiveFilters: Bool {
        !viewModel.filterState.selectedLocations.isEmpty ||
        !viewModel.filterState.selectedBrands.isEmpty ||
        !viewModel.filterState.selectedConditions.isEmpty ||
        viewModel.filterState.minPrice > 0 ||
        viewModel.filterState.maxPrice < 2000 ||
        !viewModel.searchText.isEmpty
    }
    
    private var activeFilterTags: [String] {
        var tags: [String] = []
        
        // Add location tags
        tags.append(contentsOf: viewModel.filterState.selectedLocations.map { $0 })
        
        // Add brand tags
        tags.append(contentsOf: viewModel.filterState.selectedBrands.map { $0 })
        
        // Add condition tags
        tags.append(contentsOf: viewModel.filterState.selectedConditions.map { $0.displayName })
        
        // Add price range tags
        if viewModel.filterState.minPrice > 0 || viewModel.filterState.maxPrice < 2000 {
            tags.append("\(Int(viewModel.filterState.minPrice))$ - \(Int(viewModel.filterState.maxPrice))$")
        }
        
        return tags
    }
    
    private func removeFilter(_ tag: String) {
        // Logic to remove specific filter
        if viewModel.filterState.selectedLocations.contains(tag) {
            viewModel.toggleLocation(tag)
        } else if viewModel.filterState.selectedBrands.contains(tag) {
            viewModel.toggleBrand(tag)
        } else if let condition = ProductCondition.allCases.first(where: { $0.displayName == tag }) {
            viewModel.toggleCondition(condition)
        } else if tag.contains("$") {
            viewModel.updatePriceRange(min: 0, max: 2000)
        }
    }
}

struct ActiveFilterTag: View {
    let title: String
    let onRemove: () -> Void
    
    var body: some View {
        HStack(spacing: 6) {
            Text(title)
                .font(.caption)
            
            Button(action: onRemove) {
                Image(systemName: "xmark")
                    .font(.caption2)
            }
        }
        .foregroundColor(.white)
        .padding(.horizontal, 10)
        .padding(.vertical, 6)
        .background(Color.gray)
        .cornerRadius(16)
    }
}

// MARK: - Product Results Header
struct ProductResultsHeader: View {
    @ObservedObject var viewModel: ProductCatalogViewModel
    
    var body: some View {
        HStack {
            Text("\(viewModel.productCount) products")
                .font(.subheadline)
                .fontWeight(.medium)
            
            Spacer()
            
            // Sort selector
            Menu {
                ForEach(SortOption.allCases, id: \.self) { option in
                    Button {
                        viewModel.filterState.sortOption = option
                    } label: {
                        HStack {
                            Text(option.displayName)
                            if viewModel.filterState.sortOption == option {
                                Image(systemName: "checkmark")
                            }
                        }
                    }
                }
            } label: {
                HStack(spacing: 4) {
                    Text("Sort by: \(viewModel.filterState.sortOption.displayName)")
                        .font(.subheadline)
                    Image(systemName: "chevron.down")
                        .font(.caption)
                }
                .foregroundColor(.primary)
            }
        }
        .padding(.horizontal)
        .padding(.bottom, 8)
    }
}

// MARK: - Product Grid View
struct ProductGridView: View {
    @ObservedObject var viewModel: ProductCatalogViewModel
    
    private let columns = Array(repeating: GridItem(.flexible(), spacing: 16), count: 2)
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(viewModel.filteredProducts) { product in
                    ProductCardView(product: product)
                        .onTapGesture {
                            viewModel.selectedProduct = product
                        }
                }
            }
            .padding(.horizontal)
            .padding(.bottom, 20)
        }
    }
}

#Preview {
    ContentView()
}
