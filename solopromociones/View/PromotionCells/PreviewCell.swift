//
//  PreviewCell.swift
//  solopromociones
//
//  Created by RAVIT Admin on 20/06/24.
//

import SwiftUI

import SwiftUI

struct PreviewCell: View {
    let promotion: Promotion
    let layout: CellLayoutType

    var body: some View {
        return BoldTitlePromotionCell(promotion: promotion)
        switch layout {
        case .standard:
            PromotionCell(promotion: promotion)
        case .minimalist:
            MinimalistPromotionCell(promotion: promotion)
        case .boldTitle:
            BoldTitlePromotionCell(promotion: promotion)
        case .imageFirst:
            ImageFirstPromotionCell(promotion: promotion)
        case .overlayText:
            OverlayTextPromotionCell(promotion: promotion)
        case .cardStyle:
            CardStylePromotionCell(promotion: promotion)
        case .highlightedConditions:
            HighlightedConditionsPromotionCell(promotion: promotion)
        case .bannerStyle:
            BannerStylePromotionCell(promotion: promotion)
        case .splitView:
            SplitViewPromotionCell(promotion: promotion)
        case .rounded:
            RoundedPromotionCell(promotion: promotion)
        case .detailed:
            DetailedPromotionCell(promotion: promotion)
        case .imageBackground:
            ImageBackgroundPromotionCell(promotion: promotion)
        case .circularImage:
            CircularImagePromotionCell(promotion: promotion)
        case .horizontal:
            HorizontalPromotionCell(promotion: promotion)
        case .compact:
            CompactPromotionCell(promotion: promotion)
        }
    }
}
