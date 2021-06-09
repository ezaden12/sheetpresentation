//
//  APIService.swift
//  sheetpresentation
//
//  Created by Muhamed Ezaden Seraj on 8/6/21.
//

import Foundation

protocol RequestProviding {
    var urlRequest: URLRequest { get }
}

enum Endpoint {
    case posts
}

extension Endpoint: RequestProviding {
    var urlRequest: URLRequest {
        switch self {
        case .posts:
            guard let url = URL(string: "https://jsonplaceholder.typicode.com/posts") else {
                preconditionFailure("Invalid URL used to create URL instance")
            }
            return URLRequest(url: url)
        }
    }
}

struct Post: Codable, Hashable {
    let userID, id: Int
    let title, body: String

    enum CodingKeys: String, CodingKey {
        case userID = "userId"
        case id, title, body
    }
}


class APIService {

    let urlSession = URLSession.shared

    func posts() async throws -> [Post] {
        return try await self.execute(.posts)
    }


    func execute<T: Decodable>(_ endpoint: Endpoint) async throws -> T {
        let urlRequest = endpoint.urlRequest
        guard let url = urlRequest.url else {
            throw NSError(domain: "", code: 400, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])
        }

        let data = try await urlSession.data(with: url)

        let decodedData = try JSONDecoder().decode(T.self, from: data)
        return decodedData
    }
}
