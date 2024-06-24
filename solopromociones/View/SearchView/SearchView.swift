import SwiftUI

struct SearchView: View {
    @State private var searchText = ""
    @State private var recentSearches: [String] = ["Restaurantes", "Cine", "Spa"]
    @ObservedObject var viewModel: HomeViewModel
    
    var body: some View {
        VStack(spacing: 20) {
            searchBar
            
            if searchText.isEmpty {
                recentSearchesSection
                popularCategoriesSection
            } else {
                searchResultsSection
            }
            
            Spacer()
        }
        .padding()
        .navigationTitle("Buscar")
    }
    
    private var searchBar: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
            TextField("Buscar promociones", text: $searchText)
                .textFieldStyle(RoundedBorderTextFieldStyle())
        }
    }
    
    private var recentSearchesSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Búsquedas recientes")
                .font(.headline)
            
            ForEach(recentSearches, id: \.self) { search in
                HStack {
                    Image(systemName: "clock")
                    Text(search)
                    Spacer()
                    Button(action: {
                        // Eliminar búsqueda reciente
                    }) {
                        Image(systemName: "xmark")
                    }
                }
                .padding(.vertical, 5)
            }
        }
    }
    
    private var popularCategoriesSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Categorías populares")
                .font(.headline)
            
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                ForEach(viewModel.categories.prefix(4), id: \.self) { category in
                    CategoryButton(category: category, isSelected: false, action: {})
                }
            }
        }
    }

    private var searchResultsSection: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(viewModel.searchPromotions(query: searchText), id: \.id) { promotion in
                    PromotionRow(promotion: promotion)
                }
            }
        }
    }
}
