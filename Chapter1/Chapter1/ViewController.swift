//
//  ViewController.swift
//  Chapter1
//
//  Created by 강수진 on 2022/02/06.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let plays = [
            "hamlet": Play(name: "Hamlet", type: "tragedy"),
            "as You Like It": Play(name: "As You Like It", type: "comedy"),
            "othello": Play(name: "Othello", type: "tragedy")
        ]

        let invoice = Invoice(customer: "BigCo", performances: [
            Performance(playID: "hamlet", audience: 55),
            Performance(playID: "as You Like It", audience: 35),
            Performance(playID: "othello", audience: 40)
        ])

        print(try? statement(invoice: invoice, plays: plays))
    }
    
    func statement(invoice: Invoice, plays: [String: Play]) throws -> String {
        return try renderPlainText(data: createStatementData(invoice: invoice, plays: plays))
    }

    func renderPlainText(data: StatementData) throws -> String {
        var result = "청구내역 (고객명 :\(data.customer))\n"

        for performance in data.performances {
            result += "\(performance.play?.name ?? ""): $\((performance.amount ?? .zero)/100) (\(performance.audience)석)\n"
        }

        result += "총액: $\(data.totalAmount/100.0)\n"
        result += "적립 포인트: $\(data.totalVolumeCredits)점\n"
        return result
    }
    
    func createStatementData(invoice: Invoice, plays: [String: Play]) throws -> StatementData {
        func play(for performance: Performance) -> Play? {
            return plays[performance.playID]
        }
        
        func enrichPerformance(performance: Performance) throws -> Performance {
            let calculator = try createPerformanceCalculator(performance: performance,
                                                             play: play(for: performance))
            var result = performance
            result.play = calculator.play
            result.amount = calculator.amount()
            result.volumeCredits = calculator.volumeCredits()
            return result
        }
        
        func totalAmount(for performances: [Performance]) throws -> Double {
            return performances.reduce(0) { $0 + ($1.amount ?? .zero) }
        }
        
        func totalVolumeCredits(for performances: [Performance]) -> Double {
            return performances.reduce(0) { $0 + ($1.volumeCredits ?? .zero) }
        }
        
        let enrichedPerformances = invoice.performances.compactMap { try? enrichPerformance(performance: $0) }
        let statementData = StatementData(customer: invoice.customer,
                                          performances: enrichedPerformances,
                                          totalAmount: try totalAmount(for: enrichedPerformances),
                                          totalVolumeCredits: totalVolumeCredits(for: enrichedPerformances))
        return statementData
    }
    
    func createPerformanceCalculator(performance: Performance, play: Play?) throws -> PerformanceCalculator {
        switch play?.type {
        case "tragedy":
            return TragedyCalculator(performance: performance, play: play)
        case "comedy":
            return ComedyCalculator(performance: performance, play: play)
        default:
            throw CustomError.unknown
        }
    }
}

