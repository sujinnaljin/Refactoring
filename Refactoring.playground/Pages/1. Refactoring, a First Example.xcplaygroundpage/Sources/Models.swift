import Foundation

public struct Performance {
    public let playID: String
    public let audience: Int
    
    public init(playID: String, audience: Int) {
        self.playID = playID
        self.audience = audience
    }
}

public struct Play {
    public let name: String
    public let type: String
    
    public init(name: String, type: String) {
        self.name = name
        self.type = type
    }
}

public struct Invoice {
    public let customer: String
    public let performances: [Performance]
    
    public init(customer: String, performances: [Performance]) {
        self.customer = customer
        self.performances = performances
    }
}

public enum CustomError : Error {
    case unknown
}

public struct StatementData {
    let customer: String
    let performances: [Performance]
    let totalAmount: Double
    let totalVolumeCredits: Double
    
    public init(customer: String, performances: [Performance], totalAmount: Double, totalVolumeCredits: Double) {
        self.customer = customer
        self.performances = performances
        self.totalAmount = totalAmount
        self.totalVolumeCredits = totalVolumeCredits
    }
}
