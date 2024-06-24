import SwiftUI
import Combine

struct DailyPromotionsView: View {
    @ObservedObject var viewModel = PromotionsViewModel()
    @State private var selectedCategoryIndex = 0
    @State private var showingCalendar = false
    
    var body: some View {
        VStack(spacing: 0) {
            // Barra de Navegación de Días
            ScrollViewReader { scrollProxy in
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 0) {
                        ForEach(viewModel.days.indices, id: \.self) { index in
                            DayButton(day: viewModel.days[index],
                                      isSelected: viewModel.selectedDayIndex == index,
                                      action: {
                                viewModel.selectedDayIndex = index
                                selectedCategoryIndex = 0
                            })
                            .id(index)
                        }
                        
                        Button(action: {
                            showingCalendar = true
                        }) {
                            Image(systemName: "calendar")
                                .padding()
                                .background(Color.blue.opacity(0.1))
                                .cornerRadius(10)
                        }
                    }
                }
                .padding(.vertical, 8)
                .background(Color.gray.opacity(0.1))
            }
            
            // Categorías
            if !viewModel.days.isEmpty {
                let categories = viewModel.days[viewModel.selectedDayIndex].categories
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 15) {
                        ForEach(categories.indices, id: \.self) { index in
                            CategoryButton(category: categories[index].category,
                                           isSelected: selectedCategoryIndex == index,
                                           action: {
                                withAnimation {
                                    selectedCategoryIndex = index
                                }
                            })
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.vertical, 8)
                .background(Color.gray.opacity(0.05))
            }
            
            // Promociones
            if !viewModel.days.isEmpty {
                let categories = viewModel.days[viewModel.selectedDayIndex].categories
                if categories.indices.contains(selectedCategoryIndex) {
                    ScrollView {
                        LazyVStack(spacing: 20) {
                            ForEach(categories[selectedCategoryIndex].promotions) { promotion in
                                getRandomPromotionCell(promotion: promotion)
                                    .padding(.horizontal)
                            }
                        }
                        .padding(.vertical)
                    }
                }
            }
        }
        .navigationTitle("Promociones Diarias")
        .sheet(isPresented: $showingCalendar) {
            MonthlyCalendarView(selectedDate: $viewModel.selectedDate, viewModel: viewModel)
        }
        .onChange(of: viewModel.selectedDate) { newDate in
            viewModel.loadPromotionsForDate(newDate)
        }
    }
    
    @ViewBuilder
    func getRandomPromotionCell(promotion: Promotion) -> some View {
        let randomInt = Int.random(in: 1...16)
        switch randomInt {
        case 1:
            PromotionCell(promotion: promotion)
        case 2:
            MinimalistPromotionCell(promotion: promotion)
        case 3:
            BoldTitlePromotionCell(promotion: promotion)
        case 4:
            ImageFirstPromotionCell(promotion: promotion)
        case 5:
            OverlayTextPromotionCell(promotion: promotion)
        case 6:
            CardStylePromotionCell(promotion: promotion)
        case 7:
            HighlightedConditionsPromotionCell(promotion: promotion)
        case 8:
            BannerStylePromotionCell(promotion: promotion)
        case 9:
            SplitViewPromotionCell(promotion: promotion)
        case 10:
            BoldTitlePromotionCell(promotion: promotion)
        case 11:
            RoundedPromotionCell(promotion: promotion)
        case 12:
            DetailedPromotionCell(promotion: promotion)
        case 13:
            ImageBackgroundPromotionCell(promotion: promotion)
        case 14:
            CircularImagePromotionCell(promotion: promotion)
        case 15:
            HorizontalPromotionCell(promotion: promotion)
        case 16:
            CompactPromotionCell(promotion: promotion)
        default:
            PromotionCell(promotion: promotion)
        }
    }
}

struct DayButton: View {
    let day: DayPromotion
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Text(day.formattedDay)
                    .font(.headline)
                Text(day.formattedDate)
                    .font(.subheadline)
            }
            .padding(.vertical, 8)
            .padding(.horizontal, 12)
            .background(isSelected ? Color.blue.opacity(0.2) : Color.clear)
            .cornerRadius(10)
        }
        .foregroundColor(isSelected ? .blue : .primary)
    }
}

struct DailyPromotionsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            DailyPromotionsView()
        }
    }
}
