//
//  ProductCatalogViewModel.swift
//  product-catalog
//
//  Created by Wentao Guo on 15/09/25.
//

import Foundation
import Combine
import SwiftUI

@MainActor
class ProductCatalogViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var searchText: String = ""
    var filteredProducts: [Product] = []
    @Published var filterState = FilterState()
    @Published var isFilterSheetPresented = false
    @Published var selectedProduct: Product?
    
    // MARK: - Data Properties
    private let allProducts: [Product]
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Computed Properties
    var availableLocations: [String] {
        Array(Set(allProducts.map { $0.location })).sorted()
    }
    
    var availableBrands: [String] {
        Array(Set(allProducts.map { $0.brand })).sorted()
    }
    
    var productCount: Int {
        filteredProducts.count
    }
    
    // MARK: - Initialization
    init() {
        self.allProducts = ProductDataService.sampleProducts
        setupSearchAndFiltering()
    }
    
    // MARK: - Combine Setup
    private func setupSearchAndFiltering() {
        // Incremental search - Using Combine's debounce to avoid too frequent searches
        let searchPublisher = $searchText
            .debounce(for: .milliseconds(1000), scheduler: RunLoop.main)
            .removeDuplicates()

        let filterPublisher = $filterState
            .removeDuplicates { old, new in
                // Custom comparison logic to optimize performance
                return old.selectedLocations == new.selectedLocations &&
                       old.selectedBrands == new.selectedBrands &&
                       old.selectedConditions == new.selectedConditions &&
                       old.minPrice == new.minPrice &&
                       old.maxPrice == new.maxPrice &&
                       old.sortOption == new.sortOption
            }
        
        // Combine search and filter condition changes
        Publishers.CombineLatest(searchPublisher, filterPublisher)
            .map { [weak self] searchText, filterState in
                self?.performFiltering(searchText: searchText, filterState: filterState) ?? []
            }
            .receive(on: DispatchQueue.main)
            .assign(to: \.filteredProducts, on: self)
            .store(in: &cancellables)
    }
    
    // MARK: - Filtering Logic
    private func performFiltering(searchText: String, filterState: FilterState) -> [Product] {
        var products = allProducts
        
        // Text search
        if !searchText.isEmpty {
            products = products.filter { product in
                product.name.localizedCaseInsensitiveContains(searchText) ||
                product.brand.localizedCaseInsensitiveContains(searchText) ||
                product.code.localizedCaseInsensitiveContains(searchText)
            }
        }
        
        // Location filter
        if !filterState.selectedLocations.isEmpty {
            products = products.filter { filterState.selectedLocations.contains($0.location) }
        }
        
        // Brand filter
        if !filterState.selectedBrands.isEmpty {
            products = products.filter { filterState.selectedBrands.contains($0.brand) }
        }
        
        // Condition filter
        if !filterState.selectedConditions.isEmpty {
            products = products.filter { filterState.selectedConditions.contains($0.condition) }
        }
        
        // Price range filter
        products = products.filter { product in
            product.price >= filterState.minPrice && product.price <= filterState.maxPrice
        }
        
        // Sorting
        switch filterState.sortOption {
        case .highestPrice:
            products.sort { $0.price > $1.price }
        case .lowestPrice:
            products.sort { $0.price < $1.price }
        case .rating:
            products.sort { $0.rating > $1.rating }
        case .reviews:
            products.sort { $0.reviewCount > $1.reviewCount }
        }
        
        return products
    }
    
    // MARK: - Public Methods
    
    func clearFilters() {
        filterState = FilterState()
        searchText = ""
    }
    
    func toggleLocation(_ location: String) {
        if filterState.selectedLocations.contains(location) {
            filterState.selectedLocations.remove(location)
        } else {
            filterState.selectedLocations.insert(location)
        }
    }
    
    func toggleBrand(_ brand: String) {
        if filterState.selectedBrands.contains(brand) {
            filterState.selectedBrands.remove(brand)
        } else {
            filterState.selectedBrands.insert(brand)
        }
    }
    
    func toggleCondition(_ condition: ProductCondition) {
        if filterState.selectedConditions.contains(condition) {
            filterState.selectedConditions.remove(condition)
        } else {
            filterState.selectedConditions.insert(condition)
        }
    }
    
    func updatePriceRange(min: Double, max: Double) {
        filterState.minPrice = min
        filterState.maxPrice = max
    }
}
