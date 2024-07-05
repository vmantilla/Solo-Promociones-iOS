import SwiftUI

struct PromotionsView: View {
    @ObservedObject var viewModel: PromotionsViewModel
    
    var body: some View {
        if !viewModel.days.isEmpty {
            ScrollView {
                LazyVStack(spacing: 20) {
                    ForEach(viewModel.filteredPromotions(promotions: viewModel.days[viewModel.selectedDayIndex].categories.flatMap { $0.promotions ?? [] } ?? [])) { promotion in
                        getPromotionCell(promotion: promotion)
                            .padding(.horizontal)
                    }
                }
                .padding(.vertical)
            }
        }
    }
    
    @ViewBuilder
    func getPromotionCell(promotion: Promotion) -> some View {
        switch promotion.cellType {
        case .standard:
            StandardPromotionCell(promotion: promotion)
        case .carousel:
            CarouselPromotionCell(promotions: [promotion, promotion], navigateToDetail: {_ in })
        case .compactHorizontal:
            CompactHorizontalPromotionCell(promotion: promotion)
        case .grid:
            GridPromotionCell(promotions: [promotion, promotion, promotion, promotion])
        case .featured:
            FeaturedPromotionCell(promotion: promotion)
        case .collapsible:
            CollapsiblePromotionCell(promotion: promotion)
        case .timeline:
            TimelinePromotionCell(promotions: [promotion, promotion, promotion])
        case .comparative:
            ComparativePromotionCell(promotion1: promotion, promotion2: promotion)
        case .category:
            CategoryPromotionCell(category: "Ejemplo", promotions: [promotion, promotion, promotion])
        case .countdown:
            CountdownPromotionCell(promotion: promotion)
        case .none:
            StandardPromotionCell(promotion: promotion)
        }
    }
}
