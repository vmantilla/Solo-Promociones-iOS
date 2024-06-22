import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    @State private var searchText = ""
    @State private var selectedCategories: Set<String> = []
    @State private var showCityPicker = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading) {
                    headerSection
                    searchSection
                    filterSection
                    featuredSection
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
            Text("Promoción destacada")
                .font(.title2)
                .bold()
            if let featuredPromotion = viewModel.promotions.first {
                PromotionCard(promotion: featuredPromotion)
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
                Button(action: {}) {
                    Text("Ver todas (\(viewModel.promotions.count))")
                        .foregroundColor(.blue)
                }
            }
            ForEach(viewModel.promotions) { promotion in
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
            } placeholder: {
                Color.gray
            }
            .aspectRatio(contentMode: .fill)
            .frame(height: 200)
            .clipped()
            .cornerRadius(10)
            
            Text(promotion.title)
                .font(.title2)
                .bold()
            Text(promotion.description)
                .foregroundColor(.secondary)
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

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
