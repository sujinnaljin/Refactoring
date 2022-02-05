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
        func play(for performance: Performance) -> Play? {
            return plays[performance.playID]
        }
        
        func amount(for performance: Performance) throws -> Double {
            var result: Double = 0
            switch play(for: performance)?.type {
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
        
        func volumeCredit(for performance: Performance) -> Double {
            var result: Double = 0
            result += max(Double(performance.audience) - 30, 0)
            if "comedy" == play(for: performance)?.type {
                result += floor(Double(performance.audience) / 5.0)
            }
            return result
        }
        
        func enrichPerformance(performance: Performance) throws -> Performance {
            var result = performance
            result.play = play(for: performance)
            result.amount = try amount(for: performance)
            result.volumeCredits = volumeCredit(for: performance)
            return result
        }
        
        func totalAmount(for performances: [Performance]) throws -> Double {
            var result: Double = 0
            for performance in performances {
                result += try amount(for: performance)
            }
            return result
        }
        
        func totalVolumeCredits(for performances: [Performance]) -> Double {
            var result: Double = 0
            for performance in performances {
                result += volumeCredit(for: performance)
            }
            return result
        }
        
        let statementData = StatementData(customer: invoice.customer,
                                          performances: invoice.performances.compactMap { try? enrichPerformance(performance: $0) },
                                          totalAmount: try totalAmount(for: invoice.performances),
                                          totalVolumeCredits: totalVolumeCredits(for: invoice.performances))
        
        return try renderPlainText(data: statementData)
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
}

