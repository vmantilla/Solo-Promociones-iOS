import SwiftUI

struct MonthlyCalendarView: View {
    @Binding var selectedDate: Date
    @ObservedObject var viewModel: PromotionsViewModel
    @State private var currentMonth = Date()
    @State private var selectedCategory: Category?
    @Environment(\.presentationMode) var presentationMode
    
    private let calendar = Calendar.current
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter
    }()
    
    var body: some View {
        NavigationView {
            VStack(spacing: 15) {
                categorySelectionView()
                monthNavigationView()
                weekdayHeaderView()
                calendarGridView()
                Spacer()
            }
            .padding()
            .navigationBarTitle("Calendario", displayMode: .inline)
            .navigationBarItems(trailing: Button("Cerrar") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
    
    @ViewBuilder
    private func categorySelectionView() -> some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(viewModel.allCategories) { category in
                    CategoryFilterButton(category: category,
                                         isSelected: selectedCategory == category,
                                         action: {
                        selectedCategory = (selectedCategory == category) ? nil : category
                    })
                }
            }
            .padding(.horizontal)
        }
        .padding(.top, 8)
    }
    
    @ViewBuilder
    private func monthNavigationView() -> some View {
        HStack {
            Button(action: previousMonth) {
                Image(systemName: "chevron.left")
                    .foregroundColor(.secondary)
            }
            Spacer()
            Text(dateFormatter.string(from: currentMonth))
                .font(.subheadline)
                .foregroundColor(.primary)
            Spacer()
            Button(action: nextMonth) {
                Image(systemName: "chevron.right")
                    .foregroundColor(.secondary)
            }
        }
        .padding(.horizontal)
    }
    
    @ViewBuilder
    private func weekdayHeaderView() -> some View {
        HStack {
            ForEach(["D", "L", "M", "M", "J", "V", "S"], id: \.self) { day in
                Text(day)
                    .frame(maxWidth: .infinity)
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
        }
    }
    
    @ViewBuilder
    private func calendarGridView() -> some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 6) {
            ForEach(daysInMonth(), id: \.self) { date in
                if let date = date {
                    DayCell(date: date,
                            isSelected: calendar.isDate(date, inSameDayAs: selectedDate),
                            isInCurrentMonth: calendar.isDate(date, equalTo: currentMonth, toGranularity: .month),
                            hasPromotion: viewModel.hasPromotion(on: date, category: selectedCategory))
                        .onTapGesture {
                            selectedDate = date
                            viewModel.loadPromotionsForDate(date)
                            presentationMode.wrappedValue.dismiss()
                        }
                } else {
                    Color.clear
                }
            }
        }
    }
    
    private func daysInMonth() -> [Date?] {
        let range = calendar.range(of: .day, in: .month, for: currentMonth)!
        let firstDayOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: currentMonth))!
        let firstWeekday = calendar.component(.weekday, from: firstDayOfMonth)
        
        var days: [Date?] = Array(repeating: nil, count: firstWeekday - 1)
        
        for day in 1...range.count {
            if let date = calendar.date(byAdding: .day, value: day - 1, to: firstDayOfMonth) {
                days.append(date)
            }
        }
        
        while days.count % 7 != 0 {
            days.append(nil)
        }
        
        return days
    }
    
    private func previousMonth() {
        currentMonth = calendar.date(byAdding: .month, value: -1, to: currentMonth)!
    }
    
    private func nextMonth() {
        currentMonth = calendar.date(byAdding: .month, value: 1, to: currentMonth)!
    }
}

struct DayCell: View {
    let date: Date
    let isSelected: Bool
    let isInCurrentMonth: Bool
    let hasPromotion: Bool
    
    private let calendar = Calendar.current
    
    var body: some View {
        Text("\(calendar.component(.day, from: date))")
            .frame(height: 35)
            .frame(maxWidth: .infinity)
            .background(
                Group {
                    if isSelected {
                        Circle().fill(Color.blue.opacity(0.2))
                    } else if hasPromotion {
                        Circle().fill(Color.blue.opacity(0.1))
                    }
                }
            )
            .foregroundColor(isSelected ? .blue : (isInCurrentMonth ? .primary : .secondary))
            .opacity(isInCurrentMonth ? 1 : 0.5)
            .overlay(
                Circle()
                    .stroke(Color.blue.opacity(0.5), lineWidth: calendar.isDateInToday(date) ? 1 : 0)
            )
            .font(.footnote)
    }
}

struct MonthlyCalendarView_Previews: PreviewProvider {
    static var previews: some View {
        MonthlyCalendarView(selectedDate: .constant(Date()), viewModel: PromotionsViewModel())
    }
}
