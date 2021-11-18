//
//  DateTimeManager.swift
//  Prog2WeatherProject
//
//  Created by Attila Szél on 2021. 11. 15..
//

import Foundation

final class DateTimeManager {
    
    let formatter = DateFormatter()
    
    func epochToHumanDate(timestamp: Int) -> Date {
        let epochTime = TimeInterval(timestamp)
        return Date(timeIntervalSince1970: epochTime)
    }
    
    func epochToDay(timestamp: Int) -> String {
        // expected return example -> Tuesday
        formatter.dateFormat = "EEEE"
        return formatter.string(from: epochToHumanDate(timestamp: timestamp))
    }
    
    func epochToDayDate(timestamp: Int) -> String {
        // expected return example -> Tuesday, 20 Jul
        formatter.dateFormat = "EEEE, d MMM"
        return formatter.string(from: epochToHumanDate(timestamp: timestamp))
    }
}
