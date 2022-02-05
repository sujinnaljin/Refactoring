import Foundation

public func statement(invoice: Invoice, plays: [String: Play]) throws -> String {
    var totalAmount: Double = 0
    var volumeCredits: Double = 0
    var result = "청구내역 (고객명 :\(invoice.customer))\n"

    for perf in invoice.performances {
        let play = plays[perf.playID]
        var thisAmount: Double = 0

        switch play?.type {
        case "tragedy":
            thisAmount = 40000
            if perf.audience > 30 {
                thisAmount += Double(1000 * (perf.audience - 30))
            }
        case "comedy":
            thisAmount = 30000
            if perf.audience > 20 {
                thisAmount += Double(10000 + 500 * (perf.audience - 20))
            }
            thisAmount += Double(300 * perf.audience)
        default:
            throw CustomError.unknown
        }

        volumeCredits += max(Double(perf.audience) - 30, 0)
        if "comedy" == play?.type {
            volumeCredits += floor(Double(perf.audience) / 5.0)
        }
            result += "\(play?.name ?? ""): $\(thisAmount/100) (\(perf.audience)석)\n"
            totalAmount += thisAmount

    }
    result += "총액: $\(totalAmount/100.0)\n"
    result += "적립 포인트: $\(volumeCredits)점\n"
    return result
}
