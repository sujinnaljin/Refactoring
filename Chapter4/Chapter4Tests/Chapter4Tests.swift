//
//  Chapter4Tests.swift
//  Chapter4Tests
//
//  Created by 강수진 on 2022/02/26.
//

import XCTest
@testable import Chapter4

class Chapter4Tests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testProvince_Shortfall() {
        let asia = MockParser.load(type: Province.self, fileName: "mock")
        XCTAssertEqual(asia?.shortfall, 5)
    }
}
