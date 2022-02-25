//
//  Chapter4Tests.swift
//  Chapter4Tests
//
//  Created by 강수진 on 2022/02/26.
//

@testable import Chapter4
import Quick
import Nimble

class Chapter4Tests: QuickSpec {
    
    override func spec() {
        
        // 어떤 component를 test 하는지 설명 (명사)
        describe("province") {
            var asia: Province!
            
            beforeEach {
                asia = MockParser.load(type: Province.self, fileName: "mock")
                expect(asia).toNot(beNil())
            }
            // test에서 기대되는 결과. 위에서 명사로 작성한 테스트 대상의 행동을 작성
            it("shortfall") {
                expect(asia.shortfall).to(equal(5))
            }
            
            it("profit") {
                expect(asia.profit).to(equal(230))
            }
            
            it("change production") {
                asia.producers.first?.setProduction(amountStr: "20")
                expect(asia.shortfall).to(equal(-6))
                expect(asia.profit).to(equal(292))
            }
            
            it("zero demand") {
                asia.demand = 0
                expect(asia.shortfall).to(equal(-25))
                expect(asia.profit).to(equal(0))
            }
            
            it("negative demand") {
                asia.demand = -1
                expect(asia.shortfall).to(equal(-26))
                expect(asia.profit).to(equal(-10))
            }
        }
        
        describe("no producers") {
            var noProducers: Province!
            
            beforeEach {
                noProducers = MockParser.load(type: Province.self, fileName: "NoProducers")
                expect(noProducers).toNot(beNil())
            }

            it("shortfall") {
                expect(noProducers.shortfall).to(equal(30))
            }
            
            it("profit") {
                expect(noProducers.profit).to(equal(0))
            }
        }
    }
}
