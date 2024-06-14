import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel = PromotionsViewModel()
    
    var body: some View {
        VStack {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(viewModel.days) { day in
                        VStack {
                            Text(day.formattedDate) // Utiliza la función formattedDate
                                .fontWeight(viewModel.selectedDayIndex == viewModel.days.firstIndex(where: { $0.id == day.id }) ? .bold : .regular)
                        }
                        .onTapGesture {
                            viewModel.selectedDayIndex = viewModel.days.firstIndex(where: { $0.id == day.id }) ?? 0
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                    }
                }
                .background(Color.gray.opacity(0.2))
            }
            
            // Promociones por Categoría
            if viewModel.days.indices.contains(viewModel.selectedDayIndex) {
                TabView {
                    ForEach(viewModel.days[viewModel.selectedDayIndex].categories) { category in
                        VStack {
                            Text("\(category.category) Promotions")
                                .font(.title)
                                .padding()
                            
                            List(category.promotions) { promotion in
                                VStack(alignment: .leading) {
                                    Text(promotion.title)
                                        .font(.headline)
                                    Text(promotion.description)
                                        .font(.subheadline)
                                    Text("Válido hasta: \(promotion.validUntil)")
                                        .font(.caption)
                                }
                            }
                        }
                        .tag(viewModel.days.firstIndex(where: { $0.id == category.id }) ?? 0)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
