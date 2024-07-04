import SwiftUI
import Combine

struct HomeView: View {
    @ObservedObject var viewModel: HomeViewModel
    @State private var searchText = ""
    @State private var selectedCategory: String?
    @State private var showCityPicker = false
    @State private var showCategoryPicker = false
    @State private var currentFeaturedPage = 0
    @State private var isSearchActive = false
    
    let timer = Timer.publish(every: 5, on: .main, in: .common).autoconnect()
    @Binding var selectedTab: Int
    
    var body: some View {
        ZStack {
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
                    .background(Color(.systemBackground))
                }
            }
            
            if viewModel.showError {
                ErrorView(message: viewModel.errorMessage)
                    .onTapGesture {
                        viewModel.showError = false
                    }
                    .zIndex(1)
            }
        }
        .sheet(isPresented: $showCityPicker) {
            CityPickerView(selectedCity: $viewModel.selectedCity, cities: viewModel.cities)
        }
        .sheet(isPresented: $showCategoryPicker) {
            CategoryPickerView(selectedCategory: $selectedCategory, categories: ["Todas las categorías"] + viewModel.categories)
        }
    }
    
    private var headerSection: some View {
        HStack(alignment: .bottom) {
            VStack(alignment: .leading, spacing: 4) {
                Text("Buscar promociones en")
                    .font(.footnote)
                    .foregroundColor(.secondary)
                Button(action: { showCityPicker = true }) {
                    HStack {
                        Text(viewModel.selectedCity)
                            .font(.headline)
                            .fontWeight(.semibold)
                        Image(systemName: "chevron.down")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
            }
            Spacer()
            VStack(alignment: .trailing, spacing: 4) {
                Text("Categoría")
                    .font(.footnote)
                    .foregroundColor(.secondary)
                Button(action: { showCategoryPicker = true }) {
                    HStack {
                        Text(selectedCategory ?? "Todas")
                            .font(.subheadline)
                            .fontWeight(.medium)
                        Image(systemName: "chevron.down")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
            }
        }
        .padding(.bottom, 8)
    }
    
    private var searchSection: some View {
            HStack {
                ZStack {
                    SearchBar(text: $searchText, isKeyboardEnabled: false, shouldFocus: false)
                        .opacity(0.8)
                    
                    Button(action: {
                        isSearchActive = true
                    }) {
                        Color.clear
                    }
                }
                
                Button(action: {
                    showCategoryPicker = true
                }) {
                    Image(systemName: "slider.horizontal.3")
                        .foregroundColor(.primary)
                        .padding(8)
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                }
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
            (selectedCategory == nil || selectedCategory == "Todas las categorías" || promotion.category == selectedCategory)
        }
    }
}

struct CategoryPickerView: View {
    @Binding var selectedCategory: String?
    let categories: [String]
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            List {
                ForEach(categories, id: \.self) { category in
                    Button(action: {
                        selectedCategory = category == "Todas las categorías" ? nil : category
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        HStack {
                            Text(category)
                            Spacer()
                            if category == selectedCategory || (category == "Todas las categorías" && selectedCategory == nil) {
                                Image(systemName: "checkmark")
                                    .foregroundColor(.blue)
                            }
                        }
                    }
                }
            }
            .listStyle(PlainListStyle())
            .navigationTitle("Categorías")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(trailing: Button("Cerrar") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
}
