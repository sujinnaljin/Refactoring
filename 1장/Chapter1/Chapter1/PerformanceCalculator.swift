//
//  PerformanceCalculator.swift
//  Chapter1
//
//  Created by 강수진 on 2022/02/06.
//

import Foundation

class PerformanceCalculator {
    
    let performance: Performance
    let play: Play?
    
    init(performance: Performance, play: Play?) {
        self.performance = performance
        self.play = play
    }
    
    func amount() throws -> Double {
        var result: Double = 0
        switch play?.type {
        case "tragedy":
            result = 40000
            if performance.audience > 30 {
                result += Double(1000 * (performance.audience - 30))
            }
        case "comedy":
            result = 30000
            if performance.audience > 20 {
                result += Double(10000 + 500 * (performance.audience - 20))
            }
            result += Double(300 * performance.audience)
        default:
            throw CustomError.unknown
        }
        return result
    }
    
    func volumeCredits() -> Double {
        var result: Double = 0
        result += max(Double(performance.audience) - 30, 0)
        if "comedy" == play?.type {
            result += floor(Double(performance.audience) / 5.0)
        }
        return result
    }
}
