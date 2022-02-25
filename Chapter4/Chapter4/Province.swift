//
//  Province.swift
//  Chapter4
//
//  Created by 강수진 on 2022/02/26.
//

import Foundation

class Province: Decodable {
    let name: String
    var producers: [Producer]
    var totalProduction: Int
    var demand: Int
    let price: Int
    
    enum CodingKeys: String, CodingKey {
        case name
        case producers
        case totalProduction
        case demand
        case price
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        name = try values.decode(String.self, forKey: .name)
        producers = []
        totalProduction = 0
        demand = try values.decode(Int.self, forKey: .demand)
        price = try values.decode(Int.self, forKey: .price)
        
        try values.decode([Producer].self, forKey: .producers).forEach({ producer in
            addProducer(producer: Producer(province: self, data: producer))
        })
    }
    
    var shortfall: Int {
        return demand - totalProduction
    }
    var profit: Int {
      return demandValue - demandCost
    }
    var demandValue: Int {
      return satisfiedDemand * price
    }
    var satisfiedDemand: Int {
        return min(demand, totalProduction)
    }
    var demandCost: Int {
        var remainingDemand = demand
        var result = 0
        producers
            .sorted { $0.cost < $1.cost }
            .forEach({ producer in
                let contribution = min(remainingDemand, producer.production)
                remainingDemand -= contribution
                result += contribution * producer.cost
            })
        return result
    }
    
    func addProducer(producer: Producer) {
        self.producers.append(producer)
        self.totalProduction += producer.production
    }
}
