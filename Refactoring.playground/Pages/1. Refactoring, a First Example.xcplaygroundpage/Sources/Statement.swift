import Foundation

public func statement(invoice: Invoice, plays: [String: Play]) throws -> String {
    var totalAmount: Double = 0
    var volumeCredits: Double = 0
    var result = "청구내역 (고객명 :\(invoice.customer))\n"

    for performance in invoice.performances {
        volumeCredits += max(Double(performance.audience) - 30, 0)
        if "comedy" == play(for: performance)?.type {
            volumeCredits += floor(Double(performance.audience) / 5.0)
        }
            result += "\(play(for: performance)?.name ?? ""): $\(try amountFor(performance: performance)/100) (\(performance.audience)석)\n"
            totalAmount += try amountFor(performance: performance)

    }
    result += "총액: $\(totalAmount/100.0)\n"
    result += "적립 포인트: $\(volumeCredits)점\n"
    return result
    
    func amountFor(performance: Performance) throws -> Double {
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
    
    func play(for performance: Performance) -> Play? {
        return plays[performance.playID]
    }
}
