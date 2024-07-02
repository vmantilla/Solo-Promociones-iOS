import SwiftUI
import Combine

struct HomeView: View {
    @ObservedObject var viewModel: HomeViewModel
    @State private var searchText = ""
    @State private var selectedCategories: Set<String> = []
    @State private var showCityPicker = false
    @State private var currentFeaturedPage = 0
    
    let timer = Timer.publish(every: 5, on: .main, in: .common).autoconnect()
    @Binding var selectedTab: Int
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    headerSection
                    searchSection
                    searchSection2
                    filterSection
                    featuredSection
                    dailyDealsSection
                    categoriesSection
                    nearbyPromotionsSection
                    popularPromotionsSection
                    allPromotionsSection
                }
                .padding()
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarHidden(true)
            .background(Color(.systemGroupedBackground))
        }
    }
    
    private var headerSection: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("Buscar promociones en")
                    .font(.headline)
                    .foregroundColor(.secondary)
                Button(action: { showCityPicker = true }) {
                    HStack {
                        Text(viewModel.selectedCity)
                            .font(.largeTitle)
                            .bold()
                        Image(systemName: "chevron.down")
                            .foregroundColor(.secondary)
                    }
                }
                .sheet(isPresented: $showCityPicker) {
                    CityPickerView(selectedCity: $viewModel.selectedCity, cities: viewModel.cities)
                }
            }
            Spacer()
        }
    }
    
    private var searchSection: some View {
            VStack {
                TextField("Buscar promociones", text: $searchText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.vertical, 10)
            }
        }
    
    private var searchSection2: some View {
        CompactHorizontalPromotionCell(promotion: viewModel.featuredPromotions.first ?? Promotion(id: "", title: "Buscar promociones", description: "", validUntil: "", imageURL: "", conditions: ""))
    }
    
    private var filterSection: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(viewModel.categories, id: \.self) { category in
                    CategoryButton(category: category, isSelected: selectedCategories.contains(category), useIcons: true) {
                        if selectedCategories.contains(category) {
                            selectedCategories.remove(category)
                        } else {
                            selectedCategories.insert(category)
                        }
                    }
                }
            }
        }
    }
    
    private var featuredSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Promociones destacadas")
                .font(.title2)
                .bold()
            
            CarouselPromotionCell(promotions: viewModel.featuredPromotions)
        }
    }
    
    private var dailyDealsSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Ofertas del día")
                .font(.title2)
                .bold()
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(viewModel.dailyDeals) { promotion in
                        StandardPromotionCell(promotion: promotion)
                    }
                }
            }
        }
    }
    
    private var categoriesSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Explora por categorías")
                .font(.title2)
                .bold()
            
            GridPromotionCell(promotions: viewModel.popularPromotions)
        }
    }
    
    private var nearbyPromotionsSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Cerca de ti")
                .font(.title2)
                .bold()
            
            ForEach(viewModel.nearbyPromotions) { promotion in
                PromotionRow(promotion: promotion)
            }
        }
    }
    
    private var popularPromotionsSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Promociones populares")
                .font(.title2)
                .bold()
            
            ForEach(viewModel.popularPromotions) { promotion in
                CollapsiblePromotionCell(promotion: promotion)
            }
        }
    }
    
    private var allPromotionsSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("Todas las promociones")
                    .font(.title2)
                    .bold()
                Spacer()
                Button(action: {
                    // Acción para ver todas las promociones
                }) {
                    Text("Ver todas (\(viewModel.promotions.count))")
                        .foregroundColor(.blue)
                }
            }
            ForEach(viewModel.promotions.prefix(5)) { promotion in
                PromotionCard(promotion: promotion)
            }
        }
    }
}
