//
//  Day.swift
//  solopromociones
//
//  Created by Ravit dev on 4/07/24.
//

import Foundation

struct Day: Identifiable {
    let id = UUID()
    let date: Date
    var categories: [DayCategory]
    
    var formattedDay: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE"
        return formatter.string(from: date)
    }
    
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMM"
        return formatter.string(from: date)
    }
}
