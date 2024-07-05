import SwiftUI

struct CategoryPickerView: View {
    @Binding var selectedCategory: Category?
    @State var categories: [Category] = []
    @Environment(\.presentationMode) var presentationMode
    @State private var isLoading = true
    private let categoryService = CategoryService()
    
    let columns = [
        GridItem(.adaptive(minimum: 80))
    ]
    
    var body: some View {
        NavigationView {
            ZStack {
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 20) {
                        ForEach(categories) { category in
                            CategoryFilterButton(
                                category: category,
                                isSelected: category.id == selectedCategory?.id || (category.name == "Todas las categorías" && selectedCategory == nil),
                                action: {
                                    selectedCategory = category.name == "Todas las categorías" ? nil : category
                                    categoryService.saveSelectedCategory(category: selectedCategory)
                                    presentationMode.wrappedValue.dismiss()
                                }
                            )
                        }
                    }
                    .padding()
                }
                .navigationTitle("Categorías")
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarItems(
                    leading: Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "xmark")
                            .foregroundColor(.gray)
                    },
                    trailing: Button("Limpiar") {
                        selectedCategory = nil
                        categoryService.saveSelectedCategory(category: nil)
                        presentationMode.wrappedValue.dismiss()
                    }
                    .disabled(selectedCategory == nil)
                )
                
                if isLoading {
                    ProgressView("Cargando categorías...")
                }
            }
            .onAppear {
                Task {
                    self.categories = categoryService.loadCategoriesLocally()
                    self.isLoading = false
                    
                    do {
                        let remoteCategories = try await categoryService.fetchCategories()
                        await MainActor.run {
                            self.categories = remoteCategories
                        }
                    } catch {
                        print("Error loading categories: \(error)")
                    }
                }
            }
        }
    }
}
