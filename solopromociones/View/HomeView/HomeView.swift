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
            VStack {
                NavigationLink(
                    destination: SearchView(viewModel: viewModel),
                    isActive: $isSearchActive,
                    label: { EmptyView() }
                ).hidden()
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
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
                    .padding()
                }
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarHidden(true)
                .background(Color.white)
            }
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
        ZStack {
            SearchBar(text: $searchText)
            
            Button(action: {
                isSearchActive = true
            }) {
                Color.clear
            }
        }
    }
    
    private var categorySection: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(viewModel.categories, id: \.self) { category in
                    Button(action: {
                        selectedCategory = selectedCategory == category ? nil : category
                    }) {
                        Text(category)
                            .padding(.horizontal, 14)
                            .padding(.vertical, 8)
                            .background(selectedCategory == category ? Color.blue : Color.gray.opacity(0.2))
                            .foregroundColor(selectedCategory == category ? .white : .primary)
                            .cornerRadius(20)
                    }
                }
            }
            .padding(.horizontal)
        }
    }
    
    private var featuredSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Promociones destacadas")
                .font(.title2)
                .bold()
            
            CarouselPromotionCell(promotions: filteredPromotions(viewModel.featuredPromotions))
        }
    }
    
    private var dailyDealsSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Ofertas del día")
                .font(.title2)
                .bold()
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(filteredPromotions(viewModel.dailyDeals)) { promotion in
                        StandardPromotionCell(promotion: promotion)
                            .frame(width: 280)
                    }
                }
            }
        }
    }
    
    private var nearbyPromotionsSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Cerca de ti")
                .font(.title2)
                .bold()
            
            ForEach(filteredPromotions(viewModel.nearbyPromotions)) { promotion in
                PromotionRow(promotion: promotion)
            }
        }
    }
    
    private var popularPromotionsSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Promociones populares")
                .font(.title2)
                .bold()
            
            ForEach(filteredPromotions(viewModel.popularPromotions)) { promotion in
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
                    Text("Ver todas (\(filteredPromotions(viewModel.promotions).count))")
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
