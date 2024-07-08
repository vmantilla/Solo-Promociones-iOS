import SwiftUI

struct CategoryPickerView: View {
    @Binding var selectedCategory: Category?
    @State var categories: [Category] = []
    @Environment(\.presentationMode) var presentationMode
    @State private var isLoading = true
    private let categoryService = CategoryService()
    
    let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 3)
    
    var body: some View {
        NavigationView {
            ZStack {
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 20) {
                        ForEach(categories) { category in
                            CategoryFilterButtonPickerView(
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

struct CategoryFilterButtonPickerView: View {
    let category: Category
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(isSelected ? Color.blue.opacity(0.2) : Color.white)
                        .frame(width: 60, height: 60)
                    
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(isSelected ? Color.blue : category.color, lineWidth: 2)
                        .frame(width: 64, height: 64)
                    
                    Image(systemName: category.iconName)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 30, height: 30)
                        .foregroundColor(isSelected ? .blue : category.color)
                }
                
                Text(category.name)
                    .font(.system(size: 13, weight: .medium))
                    .foregroundColor(.primary)
                    .lineLimit(2)
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
                    .frame(width: 90)
            }
            .frame(height: 120)
            .padding(.horizontal, 5)
        }
    }
}
