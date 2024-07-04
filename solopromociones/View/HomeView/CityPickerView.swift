import SwiftUI

struct CityPickerView: View {
    @Binding var selectedCity: String
    let cities: [City]
    @Environment(\.presentationMode) var presentationMode
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(cities) { city in
                        Button(action: {
                            selectedCity = city.name
                            presentationMode.wrappedValue.dismiss()
                        }) {
                            VStack {
                                Image(systemName: "building.2.fill")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(height: 30)
                                    .foregroundColor(.gray)
                                    .padding(.bottom, 10)
                                
                                Text(city.name)
                                    .font(.subheadline)
                                    .foregroundColor(.primary)
                            }
                            .frame(height: 120)
                            .frame(maxWidth: .infinity)
                            .background(Color(.systemGray6))
                            .cornerRadius(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(selectedCity == city.name ? Color.blue : Color.clear, lineWidth: 2)
                            )
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("Seleccionar ciudad")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(leading: Button(action: {
                presentationMode.wrappedValue.dismiss()
            }) {
                Image(systemName: "xmark")
                    .foregroundColor(.gray)
            })
        }
    }
}
