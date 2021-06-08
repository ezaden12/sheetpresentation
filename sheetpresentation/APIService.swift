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

    func getPosts(_ completion: @escaping (Result<[Post], Error>) -> Void) {
        self.execute(.posts, completion: completion)
    }

    func execute<T: Decodable>(_ endpoint: Endpoint, completion: @escaping (Result<T, Error>) -> Void) {
        let urlRequest = endpoint.urlRequest

        URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            do {
                if let error = error {
                    completion(.failure(error))
                    return
                }

                guard let data = data else {
                    preconditionFailure("No error was received but we also don't have data...")
                }

                let decodedObject = try JSONDecoder().decode(T.self, from: data)

                completion(.success(decodedObject))
            } catch {
                completion(.failure(error))
            }
        }.resume()

    }
}
