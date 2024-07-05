//
//  DayNavigationView.swift
//  solopromociones
//
//  Created by Ravit dev on 5/07/24.
//

import SwiftUI

struct DayNavigationView: View {
    @ObservedObject var viewModel: PromotionsViewModel
    @Binding var showingCalendar: Bool
    
    var body: some View {
        ScrollViewReader { scrollProxy in
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    Button(action: { showingCalendar = true }) {
                        Image(systemName: "calendar")
                            .padding(8)
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(8)
                    }
                    .foregroundColor(.secondary)
                    .padding(.leading, 16)
                    
                    ForEach(viewModel.days.indices, id: \.self) { index in
                        DayButton(day: viewModel.days[index],
                                  isSelected: viewModel.selectedDayIndex == index,
                                  action: {
                            viewModel.selectedDayIndex = index
                            viewModel.selectedCategory = nil // Asignar nil directamente
                        })
                        .id(index)
                    }
                }
                .padding(.trailing, 16)
            }
            .padding(.vertical, 8)
            .background(Color.gray.opacity(0.05))
        }
    }
}
