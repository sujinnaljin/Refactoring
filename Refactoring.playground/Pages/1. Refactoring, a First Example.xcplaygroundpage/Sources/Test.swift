import XCTest

public class TestRefactoring: XCTestCase {

    public func test_statement() throws {
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

        let givenString = "청구내역 (고객명 :BigCo)\nHamlet: $650.0 (55석)\nAs You Like It: $580.0 (35석)\nOthello: $500.0 (40석)\n총액: $1730.0\n적립 포인트: $47.0점\n"
        let resultString = try statement(invoice:invoice , plays: plays)
        XCTAssertEqual(givenString, resultString)
    }

}
