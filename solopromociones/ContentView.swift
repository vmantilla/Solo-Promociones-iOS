import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel = PromotionsViewModel()

    var body: some View {
        VStack {
            // Barra de Navegación de Días
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(viewModel.days) { day in
                        Text(day.day)
                            .fontWeight(viewModel.selectedDayIndex == viewModel.days.firstIndex(where: { $0.id == day.id }) ? .bold : .regular)
                            .onTapGesture {
                                viewModel.selectedDayIndex = viewModel.days.firstIndex(where: { $0.id == day.id }) ?? 0
                            }
                            .frame(maxWidth: .infinity)
                    }
                }
                .padding()
                .background(Color.gray.opacity(0.2))
            }

            // Promociones del Día
            TabView(selection: $viewModel.selectedDayIndex) {
                ForEach(viewModel.days) { day in
                    VStack {
                        Text("Promociones para \(day.day)")
                            .font(.title)
                            .padding()
                        
                        List(day.promotions) { promotion in
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
                    .tag(viewModel.days.firstIndex(where: { $0.id == day.id }) ?? 0)
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
