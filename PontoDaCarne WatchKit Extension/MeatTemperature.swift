//
//  MeatTemperature.swift
//  PontoDaCarne WatchKit Extension
//
//  Created by Jonatas Alves santos on 14/05/22.
//

import Foundation

enum MeatTemperature: Int {
    case rare = 0
    case mediumRare
    case medium
    case welldone
    
    var stringValue: String {
        let temperature = ["Cru", "Mal passado", "Ao Pontos", "Bem passado"]
        return temperature[self.rawValue]
    }
    
    var timeModifier:Double {
        let modifier = [0.5, 0.75, 1.0, 1.5]
        return modifier[self.rawValue]
    }
    
    func cookTimeForKg(_ kg:Double) -> TimeInterval {
        let baseTime: TimeInterval = 60 * 1.3
        let baseWeight = 0.5
        let weightModifier = kg/baseWeight
        return baseTime * weightModifier * self.timeModifier
    }
}
