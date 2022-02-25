//
//  MockParser.swift
//  Chapter4
//
//  Created by 강수진 on 2022/02/26.
//

import Foundation

final class MockParser {
    static func load<T: Decodable>(type: T.Type, fileName: String) -> T? {
        guard let path = Bundle.main.path(forResource: fileName, ofType: "json") else {
            return nil
        }
        let fileURL = URL(fileURLWithPath: path)
        guard let data = try? Data(contentsOf: fileURL) else {
            return nil
        }
        guard let jsonObject = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) else {
            return nil
        }
        guard let decodable = try? JSONSerialization.data(withJSONObject: jsonObject) else { return nil }
        return try? JSONDecoder().decode(T.self, from: decodable)
    }
}
