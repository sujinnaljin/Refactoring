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
            var asia: Province?
            
            beforeEach {
                asia = MockParser.load(type: Province.self, fileName: "mock")
            }
            // test에서 기대되는 결과. 위에서 명사로 작성한 테스트 대상의 행동을 작성
            it("shortfall") {
                expect(asia?.shortfall).to(equal(5))
            }
            
            it("profit") {
                expect(asia?.profit).to(equal(230))
            }
        }
    }
}
