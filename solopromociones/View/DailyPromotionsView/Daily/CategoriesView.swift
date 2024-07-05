//
//  CategoriesView.swift
//  solopromociones
//
//  Created by Ravit dev on 5/07/24.
//

import SwiftUI

struct CategoriesView: View {
    @ObservedObject var viewModel: PromotionsViewModel
    
    var body: some View {
        if !viewModel.days.isEmpty {
            let categories = viewModel.allCategories
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 15) {
                    ForEach(categories) { category in
                        CategoryFilterButton(
                            category: category,
                            isSelected: viewModel.selectedCategory?.id == category.id,
                            action: {
                                viewModel.selectCategory(category)
                            }
                        )
                    }
                }
                .padding(.horizontal)
            }
            .padding(.vertical, 8)
            .background(Color.gray.opacity(0.05))
        }
    }
}
