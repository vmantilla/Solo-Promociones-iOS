import SwiftUI

struct CityPickerView: View {
    @Binding var selectedCity: String
    @State var cities: [City] = []
    @Environment(\.presentationMode) var presentationMode
    @State private var isLoading = true
    private let cityService = CityService()
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        NavigationView {
            ZStack {
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 20) {
                        ForEach(cities) { city in
                            Button(action: {
                                selectedCity = city.name
                                cityService.saveSelectedCity(city: city.name)
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
                
                if isLoading {
                    ProgressView("Cargando ciudades...")
                }
            }
            .onAppear {
                Task {
                    self.cities = cityService.loadCitiesLocally()
                    self.isLoading = false
                    
                    do {
                        let remoteCities = try await cityService.fetchCities()
                        await MainActor.run {
                            self.cities = remoteCities
                        }
                    } catch {
                        print("Error loading cities: \(error)")
                    }
                }
            }
        }
    }
}
