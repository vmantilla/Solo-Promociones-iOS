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
                VStack(alignment: .leading) {
                    headerSection
                    searchSection
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
    
    private var filterSection: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(viewModel.categories, id: \.self) { category in
                    filterButton(title: category)
                }
            }
        }
        .padding(.vertical)
    }
    
    private func filterButton(title: String) -> some View {
        Button(action: {
            if selectedCategories.contains(title) {
                selectedCategories.remove(title)
            } else {
                selectedCategories.insert(title)
            }
        }) {
            Text(title)
                .font(.subheadline)
                .padding()
                .background(selectedCategories.contains(title) ? Color.blue : Color(.systemGray6))
                .foregroundColor(selectedCategories.contains(title) ? .white : .primary)
                .cornerRadius(20)
        }
    }
    
    private var featuredSection: some View {
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Text("Promociones destacadas")
                        .font(.title2)
                        .bold()
                    Spacer()
                    Button(action: {
                        // Acción para ver todas las promociones destacadas
                    }) {
                        Text("Ver todas")
                            .foregroundColor(.blue)
                    }
                }
                
                TabView(selection: $currentFeaturedPage) {
                    ForEach(viewModel.featuredPromotions.indices, id: \.self) { index in
                        PromotionCard(promotion: viewModel.featuredPromotions[index])
                            .tag(index)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .frame(height: 300)
                .onReceive(timer) { _ in
                    withAnimation {
                        currentFeaturedPage = (currentFeaturedPage + 1) % viewModel.featuredPromotions.count
                    }
                }
                
                HStack {
                    Spacer()
                    ForEach(0..<viewModel.featuredPromotions.count, id: \.self) { index in
                        Circle()
                            .fill(currentFeaturedPage == index ? Color.blue : Color.gray)
                            .frame(width: 8, height: 8)
                    }
                    Spacer()
                }
                .padding(.top, 8)
            }
            .padding(.vertical)
        }
        
    private var dailyDealsSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Ofertas del día")
                .font(.title2)
                .bold()
            
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 16) {
                    ForEach(viewModel.dailyDeals) { promotion in
                        PromotionCard(promotion: promotion)
                            .frame(width: 280)
                            .frame(height: 350)  // Ajusta esta altura según sea necesario
                    }
                }
                .padding(.horizontal)
            }
            .frame(height: 370)  // Ajusta esta altura según sea necesario
        }
        .padding(.vertical)
    }
    
    private var categoriesSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Explora por categorías")
                .font(.title2)
                .bold()
            
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 0) {
                ForEach(viewModel.categories, id: \.self) { category in
                    CategoryButton(category: category, isSelected: false, useIcons: true, action: {})
                }
            }
        }
        .padding(.vertical)
    }

    
    private var nearbyPromotionsSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Cerca de ti")
                .font(.title2)
                .bold()
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(viewModel.nearbyPromotions) { promotion in
                        PromotionRow(promotion: promotion)
                            .frame(width: 280)
                    }
                }
            }
        }
        .padding(.vertical)
    }
    
    private var popularPromotionsSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Promociones populares")
                .font(.title2)
                .bold()
            
            ForEach(viewModel.popularPromotions) { promotion in
                PromotionRow(promotion: promotion)
            }
        }
        .padding(.vertical)
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
                PromotionRow(promotion: promotion)
            }
        }
        .padding(.vertical)
    }
}

struct CityPickerView: View {
    @Binding var selectedCity: String
    let cities: [City]
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            List(cities) { city in
                Button(action: {
                    selectedCity = city.name
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text(city.name)
                }
            }
            .navigationTitle("Seleccionar ciudad")
            .navigationBarItems(trailing: Button("Cerrar") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
}

struct PromotionCard: View {
    let promotion: Promotion
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            AsyncImage(url: URL(string: promotion.imageURL)) { image in
                image.resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                Color.gray
            }
            .frame(height: 180)
            .clipped()
            .cornerRadius(10)
            
            Text(promotion.title)
                .font(.headline)
                .lineLimit(2)
            
            Text(promotion.description)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .lineLimit(2)
            
            Text("Válido hasta: \(promotion.validUntil)")
                .font(.caption)
                .foregroundColor(.blue)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(15)
        .shadow(radius: 5)
    }
}

struct PromotionRow: View {
    let promotion: Promotion
    
    var body: some View {
        HStack {
            AsyncImage(url: URL(string: promotion.imageURL)) { image in
                image.resizable()
            } placeholder: {
                Color.gray
            }
            .frame(width: 80, height: 80)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            
            VStack(alignment: .leading) {
                Text(promotion.title)
                    .font(.headline)
                Text("promotion.category")
                    .foregroundColor(.blue)
                    .font(.subheadline)
            }
            Spacer()
        }
        .padding(.vertical, 5)
    }
}

