import SwiftUI

struct SearchView: View {
    @State private var searchText = ""
    @State private var recentSearches: [String] = ["Restaurantes", "Cine", "Spa"]
    @ObservedObject var viewModel: HomeViewModel
    @State private var isSearching = false
    @FocusState private var isFocused: Bool

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                SearchBar(text: $searchText, shouldFocus: isFocused)
                    .focused($isFocused)

                if searchText.isEmpty {
                    recentSearchesSection
                    popularCategoriesSection
                } else if searchText.count >= 4 {
                    searchResultsSection
                }

                Spacer()
            }
            .padding(.horizontal)
            .gesture(DragGesture().onChanged { _ in
                hideKeyboard()
            })
        }
        .navigationTitle("Buscar")
        .onAppear {
            isFocused = true // Ensure the search bar is focused when the view appears
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
                        if let index = recentSearches.firstIndex(of: search) {
                            recentSearches.remove(at: index)
                        }
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

            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                ForEach(viewModel.categories.prefix(4), id: \.self) { category in
                    CategoryButton(category: category, isSelected: false, useIcons: true, action: {})
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
            .onTapGesture {
                hideKeyboard()
            }
        }
    }

    private func hideKeyboard() {
        isFocused = false // Hide keyboard by setting focus to false
    }
}

