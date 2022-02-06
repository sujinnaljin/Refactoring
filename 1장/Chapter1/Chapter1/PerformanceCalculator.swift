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
    
    func amount() -> Double {
        fatalError("서브클래스 설계 되어야함")
    }
    
    func volumeCredits() -> Double {
        return max(Double(performance.audience) - 30, 0)
    }
}

class TragedyCalculator: PerformanceCalculator {
    override func amount() -> Double {
        var result: Double = 40000
        if performance.audience > 30 {
            result += Double(1000 * (performance.audience - 30))
        }
        return result
    }
}

class ComedyCalculator: PerformanceCalculator {
    override func amount() -> Double {
        var result: Double = 30000
        if performance.audience > 20 {
            result += Double(10000 + 500 * (performance.audience - 20))
        }
        result += Double(300 * performance.audience)
        return result
    }
    
    override func volumeCredits() -> Double {
        return super.volumeCredits() + floor(Double(performance.audience) / 5.0)
    }
}
