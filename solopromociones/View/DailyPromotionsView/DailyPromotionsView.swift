import SwiftUI
import Combine

struct DailyPromotionsView: View {
    @ObservedObject var viewModel = PromotionsViewModel()
    @State private var selectedCategoryIndex = 0
    @State private var showingCalendar = false
    @State private var isCustomDateSelected = false
    
    var body: some View {
        VStack(spacing: 0) {
            if isCustomDateSelected {
                // Vista para fecha seleccionada del calendario
                HStack {
                    VStack(alignment: .leading) {
                        Text("Fecha seleccionada:")
                            .font(.footnote)
                            .foregroundColor(.secondary)
                        Text(viewModel.selectedDate, style: .date)
                            .font(.subheadline)
                            .foregroundColor(.primary)
                    }
                    Spacer()
                    Button(action: {
                        isCustomDateSelected = false
                        viewModel.resetToCurrentDay()
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.secondary)
                    }
                }
                .padding()
                .background(Color.blue.opacity(0.1))
                .cornerRadius(10)
                .padding(.horizontal)
                .padding(.top, 8)
            } else {
                // Barra de Navegación de Días modificada
                ScrollViewReader { scrollProxy in
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 10) {
                            Button(action: {
                                showingCalendar = true
                            }) {
                                Image(systemName: "calendar")
                                    .padding(8)
                                    .background(Color.gray.opacity(0.1))
                                    .cornerRadius(8)
                            }
                            .foregroundColor(.secondary)
                            .padding(.leading, 16) // Añadido padding a la izquierda
                            
                            ForEach(viewModel.days.indices, id: \.self) { index in
                                DayButton(day: viewModel.days[index],
                                          isSelected: viewModel.selectedDayIndex == index,
                                          action: {
                                    viewModel.selectedDayIndex = index
                                    selectedCategoryIndex = 0
                                })
                                .id(index)
                            }
                        }
                        .padding(.trailing, 16) // Añadido padding a la derecha
                    }
                    .padding(.vertical, 8)
                    .background(Color.gray.opacity(0.05))
                }
            }
            
            // Categorías
            if !viewModel.days.isEmpty {
                let categories = viewModel.days[viewModel.selectedDayIndex].categories
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 15) {
                        ForEach(categories.indices, id: \.self) { index in
                            CategoryFilterButton(
                                category: categories[index].category,
                                isSelected: selectedCategoryIndex == index, useIcons: true,
                                action: {
                                    withAnimation {
                                        selectedCategoryIndex = index
                                    }
                                }
                            )
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
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showingCalendar) {
            MonthlyCalendarView(selectedDate: $viewModel.selectedDate, viewModel: viewModel)
        }
        .onChange(of: viewModel.selectedDate) { newDate in
            viewModel.loadPromotionsForDate(newDate)
            isCustomDateSelected = true
        }
    }
    
    @ViewBuilder
    func getRandomPromotionCell(promotion: Promotion) -> some View {
        let randomInt = Int.random(in: 1...10)
        switch randomInt {
        case 1:
            StandardPromotionCell(promotion: promotion)
        case 2:
            CarouselPromotionCell(promotions: [promotion, promotion])
        case 3:
            CompactHorizontalPromotionCell(promotion: promotion)
        case 4:
            GridPromotionCell(promotions: [promotion, promotion, promotion, promotion])
        case 5:
            FeaturedPromotionCell(promotion: promotion)
        case 6:
            CollapsiblePromotionCell(promotion: promotion)
        case 7:
            TimelinePromotionCell(promotions: [promotion, promotion, promotion])
        case 8:
            ComparativePromotionCell(promotion1: promotion, promotion2: promotion)
        case 9:
            CategoryPromotionCell(category: "Ejemplo", promotions: [promotion, promotion, promotion])
        case 10:
            CountdownPromotionCell(promotion: promotion)
        default:
            StandardPromotionCell(promotion: promotion)
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
                    .font(.footnote)
                Text(day.formattedDate)
                    .font(.caption)
            }
            .padding(.vertical, 8)
            .padding(.horizontal, 12)
            .background(isSelected ? Color.blue.opacity(0.1) : Color.clear)
            .cornerRadius(8)
        }
        .foregroundColor(isSelected ? .blue : .secondary)
    }
}

struct DailyPromotionsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            DailyPromotionsView()
        }
    }
}
