//
//  StatView.swift
//  solopromociones
//
//  Created by RAVIT Admin on 2/07/24.
//

import SwiftUI

struct StatView: View {
    let title: String
    let value: String
    
    var body: some View {
        VStack {
            Text(value)
                .font(.title3)
                .fontWeight(.bold)
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
}
