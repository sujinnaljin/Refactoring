//
//  Models.swift
//  Chapter1
//
//  Created by 강수진 on 2022/02/06.
//

import Foundation

struct Performance {
    let playID: String
    let audience: Int
    var play: Play?
    var amount: Double?
    var volumeCredits: Double?
}

struct Play {
    let name: String
    let type: String
}

struct Invoice {
    let customer: String
    let performances: [Performance]
}

enum CustomError : Error {
    case unknown
}

struct StatementData {
    let customer: String
    let performances: [Performance]
    let totalAmount: Double
    let totalVolumeCredits: Double
}
