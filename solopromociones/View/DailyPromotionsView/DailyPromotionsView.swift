import SwiftUI
import Lottie

struct DailyPromotionsView: View {
    @StateObject var viewModel = PromotionsViewModel()
    @State private var showingCalendar = false
    @State private var isCustomDateSelected = false
    @State private var isLoading = false
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                if isCustomDateSelected {
                    CustomDateView(viewModel: viewModel, isCustomDateSelected: $isCustomDateSelected)
                } else {
                    DayNavigationView(viewModel: viewModel, showingCalendar: $showingCalendar)
                }
                
                CategoriesView(viewModel: viewModel)
                
                if isLoading {
                    LoadingView()
                } else if viewModel.promotions.isEmpty {
                    EmptyPromotionsView()
                } else {
                    PromotionsView(viewModel: viewModel)
                }
            }
            .navigationTitle("Promociones Diarias")
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $showingCalendar) {
                MonthlyCalendarView(selectedDate: $viewModel.selectedDate, viewModel: viewModel)
            }
            .onChange(of: viewModel.selectedDate) { newDate in
                Task {
                    await loadPromotionsForDate(newDate)
                }
            }
            .onChange(of: viewModel.selectedCategory) { _ in
                Task {
                    await loadPromotionsForCurrentSelection()
                }
            }
        }
    }
    
    private func loadPromotionsForDate(_ date: Date) async {
        isLoading = true
        isCustomDateSelected = true
        await viewModel.loadPromotionsForDate(date)
        isLoading = false
    }
    
    private func loadPromotionsForCurrentSelection() async {
        isLoading = true
        await viewModel.loadPromotionsForCurrentSelection()
        isLoading = false
    }
}

struct CustomDateView: View {
    @ObservedObject var viewModel: PromotionsViewModel
    @Binding var isCustomDateSelected: Bool
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("Fecha seleccionada:")
                    .font(.footnote)
                    .foregroundColor(.secondary)
                Text(viewModel.selectedDate, style: .date)
                    .font(.subheadline)
                    .foregroundColor(.primary)
            }
            Spacer()
            Button(action: {
                isCustomDateSelected = false
                Task {
                    await viewModel.resetToCurrentDay()
                }
            }) {
                Image(systemName: "xmark.circle.fill")
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .background(Color.blue.opacity(0.1))
        .cornerRadius(10)
        .padding(.horizontal)
        .padding(.top, 8)
    }
}

struct DayButton: View {
    let day: DayPromotion
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Text(day.formattedDay)
                    .font(.footnote)
                Text(day.formattedDate)
                    .font(.caption)
            }
            .padding(.vertical, 8)
            .padding(.horizontal, 12)
            .background(isSelected ? Color.blue.opacity(0.1) : Color.clear)
            .cornerRadius(8)
        }
        .foregroundColor(isSelected ? .blue : .secondary)
    }
}

struct EmptyPromotionsView: View {
    var body: some View {
        VStack {
            Spacer()
            Text("No hay promociones disponibles.")
                .font(.title2)
                .foregroundColor(.secondary)
                .padding()
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemBackground))
    }
}
