import SwiftUI

struct DailyPromotionsView: View {
    @ObservedObject var viewModel = PromotionsViewModel()
    
    var body: some View {
        VStack {
            // Barra de Navegación de Días
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(viewModel.days) { day in
                        VStack {
                            // Mostramos el nombre del día y la fecha de manera formateada
                            Text("\(day.formattedDay) \(day.formattedDate)")
                                .fontWeight(viewModel.selectedDayIndex == viewModel.days.firstIndex(where: { $0.id == day.id }) ? .bold : .regular)
                        }
                        .onTapGesture {
                            viewModel.selectedDayIndex = viewModel.days.firstIndex(where: { $0.id == day.id }) ?? 0
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                    }
                }
                .background(Color.gray.opacity(0.2))
            }
            
            // Promociones por Categoría
            if viewModel.days.indices.contains(viewModel.selectedDayIndex) {
                TabView {
                    ForEach(viewModel.days[viewModel.selectedDayIndex].categories) { category in
                        VStack {
                            Text("\(category.category) Promotions")
                                .font(.title)
                                .padding(.top) // Añadimos padding top para evitar que el título tape la celda
                            
                            ScrollView {
                                ForEach(category.promotions) { promotion in
                                    getRandomPromotionCell(promotion: promotion)
                                }
                            }
                            .padding(.top) // Añadimos padding top para el scroll view
                        }
                        .tag(viewModel.days.firstIndex(where: { $0.id == category.id }) ?? 0)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            }
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

struct DailyPromotionsView_Previews: PreviewProvider {
    static var previews: some View {
        DailyPromotionsView()
    }
}
