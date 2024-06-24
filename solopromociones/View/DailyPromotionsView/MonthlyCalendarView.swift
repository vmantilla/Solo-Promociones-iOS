import SwiftUI

struct MonthlyCalendarView: View {
    @Binding var selectedDate: Date
    @ObservedObject var viewModel: PromotionsViewModel
    @State private var currentMonth = Date()
    @State private var selectedCategory: String?
    @Environment(\.presentationMode) var presentationMode
    
    private let calendar = Calendar.current
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter
    }()
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Button(action: previousMonth) {
                        Image(systemName: "chevron.left")
                    }
                    Spacer()
                    Text(dateFormatter.string(from: currentMonth))
                        .font(.headline)
                    Spacer()
                    Button(action: nextMonth) {
                        Image(systemName: "chevron.right")
                    }
                }
                .padding()
                
                // Category selection
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(viewModel.allCategories, id: \.self) { category in
                            CategoryButton(category: category,
                                           isSelected: selectedCategory == category,
                                           action: {
                                selectedCategory = (selectedCategory == category) ? nil : category
                            })
                        }
                    }
                    .padding(.horizontal)
                }
                
                // Calendar grid
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 10) {
                    ForEach(daysInMonth(), id: \.self) { date in
                        if let date = date {
                            DayCell(date: date, hasPromotion: viewModel.hasPromotion(on: date, category: selectedCategory))
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
                .padding()
            }
            .navigationBarTitle("Calendario", displayMode: .inline)
            .navigationBarItems(trailing: Button("Cerrar") {
                presentationMode.wrappedValue.dismiss()
            })
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
    let hasPromotion: Bool
    
    private let calendar = Calendar.current
    
    var body: some View {
        Text("\(calendar.component(.day, from: date))")
            .frame(height: 40)
            .background(hasPromotion ? Color.blue.opacity(0.3) : Color.clear)
            .cornerRadius(20)
            .overlay(
                Circle()
                    .stroke(Color.blue, lineWidth: calendar.isDateInToday(date) ? 2 : 0)
            )
    }
}

struct MonthlyCalendarView_Previews: PreviewProvider {
    static var previews: some View {
        MonthlyCalendarView(selectedDate: .constant(Date()), viewModel: PromotionsViewModel())
    }
}
