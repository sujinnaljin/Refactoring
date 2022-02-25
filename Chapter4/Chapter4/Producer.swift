//
//  Producer.swift
//  Chapter4
//
//  Created by 강수진 on 2022/02/26.
//

import Foundation

class Producer: Decodable {
    let name: String
    let cost: Int
    var production: Int
    weak var province: Province?
    
    init(province: Province, data: Producer) {
        self.province = province
        self.cost = data.cost
        self.name = data.name
        self.production = data.production
    }
    
    func setProduction(amountStr: String) {
        let amount = Int(amountStr)
        let newProduction = amount ?? 0
        province?.totalProduction += newProduction - production
        production = newProduction
    }
}
