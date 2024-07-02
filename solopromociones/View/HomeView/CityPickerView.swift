//
//  CityPickerView.swift
//  solopromociones
//
//  Created by RAVIT Admin on 2/07/24.
//

import SwiftUI

struct CityPickerView: View {
    @Binding var selectedCity: String
    let cities: [City]
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            List(cities) { city in
                Button(action: {
                    selectedCity = city.name
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text(city.name)
                }
            }
            .navigationTitle("Seleccionar ciudad")
            .navigationBarItems(trailing: Button("Cerrar") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
}

struct CityPickerView_Previews: PreviewProvider {
    static var previews: some View {
        CityPickerView(selectedCity: .constant(""), cities: [])
    }
}
