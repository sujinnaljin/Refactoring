//: [Previous](@previous)

import Foundation

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

print(try statement(invoice: invoice, plays: plays))

TestRefactoring.defaultTestSuite.run()
