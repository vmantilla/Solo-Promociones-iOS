import SwiftUI
import Combine

struct HomeView: View {
    @ObservedObject var viewModel: HomeViewModel
    @State private var searchText = ""
    @State private var selectedCategory: String?
    @State private var showCityPicker = false
    @State private var currentFeaturedPage = 0
    @State private var isSearchActive = false
    
    let timer = Timer.publish(every: 5, on: .main, in: .common).autoconnect()
    @Binding var selectedTab: Int
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                NavigationLink(
                    destination: SearchView(viewModel: viewModel),
                    isActive: $isSearchActive,
                    label: { EmptyView() }
                ).hidden()
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        headerSection
                        searchSection
                        categorySection
                        if !filteredPromotions(viewModel.featuredPromotions).isEmpty {
                            featuredSection
                        }
                        if !filteredPromotions(viewModel.dailyDeals).isEmpty {
                            dailyDealsSection
                        }
                        if !filteredPromotions(viewModel.nearbyPromotions).isEmpty {
                            nearbyPromotionsSection
                        }
                        if !filteredPromotions(viewModel.popularPromotions).isEmpty {
                            popularPromotionsSection
                        }
                        if !filteredPromotions(viewModel.promotions).isEmpty {
                            allPromotionsSection
                        }
                    }
                    .padding(.horizontal)
                }
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarHidden(true)
                .background(Color(UIColor.systemBackground))
            }
        }
    }
    
    private var headerSection: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("Buscar promociones en")
                    .font(.footnote)
                    .foregroundColor(.secondary)
                Button(action: { showCityPicker = true }) {
                    HStack {
                        Text(viewModel.selectedCity)
                            .font(.title2)
                            .fontWeight(.semibold)
                        Image(systemName: "chevron.down")
                            .font(.caption)
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
        ZStack {
            SearchBar(text: $searchText, isKeyboardEnabled: false, shouldFocus: false)
                .opacity(0.8)
            
            Button(action: {
                isSearchActive = true
            }) {
                Color.clear
            }
        }
    }
    
    private var categorySection: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(viewModel.categories, id: \.self) { category in
                    Button(action: {
                        selectedCategory = selectedCategory == category ? nil : category
                    }) {
                        Text(category)
                            .font(.footnote)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(selectedCategory == category ? Color.blue.opacity(0.2) : Color.gray.opacity(0.1))
                            .foregroundColor(selectedCategory == category ? .blue : .primary)
                            .cornerRadius(16)
                    }
                }
            }
            .padding(.horizontal, 4)
        }
    }
    
    private var featuredSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Promociones destacadas")
                .font(.headline)
                .fontWeight(.medium)
            
            CarouselPromotionCell(promotions: filteredPromotions(viewModel.featuredPromotions))
        }
    }
    
    private var dailyDealsSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Ofertas del día")
                .font(.headline)
                .fontWeight(.medium)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(filteredPromotions(viewModel.dailyDeals)) { promotion in
                        StandardPromotionCell(promotion: promotion)
                            .frame(width: 260)
                    }
                }
            }
        }
    }
    
    private var nearbyPromotionsSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Cerca de ti")
                .font(.headline)
                .fontWeight(.medium)
            
            ForEach(filteredPromotions(viewModel.nearbyPromotions)) { promotion in
                PromotionRow(promotion: promotion)
            }
        }
    }
    
    private var popularPromotionsSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Promociones populares")
                .font(.headline)
                .fontWeight(.medium)
            
            ForEach(filteredPromotions(viewModel.popularPromotions)) { promotion in
                CollapsiblePromotionCell(promotion: promotion)
            }
        }
    }
    
    private var allPromotionsSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("Todas las promociones")
                    .font(.headline)
                    .fontWeight(.medium)
                Spacer()
                Button(action: {
                    // Acción para ver todas las promociones
                }) {
                    Text("Ver todas (\(filteredPromotions(viewModel.promotions).count))")
                        .font(.footnote)
                        .foregroundColor(.blue)
                }
            }
            ForEach(filteredPromotions(viewModel.promotions).prefix(5)) { promotion in
                PromotionCard(promotion: promotion)
            }
        }
    }
    
    private func filteredPromotions(_ promotions: [Promotion]) -> [Promotion] {
        promotions.filter { promotion in
            (searchText.isEmpty || promotion.title.localizedCaseInsensitiveContains(searchText)) &&
            (selectedCategory == nil || promotion.category == selectedCategory)
        }
    }
}
