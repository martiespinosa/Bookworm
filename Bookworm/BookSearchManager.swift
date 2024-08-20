//
//  BookSearchManager.swift
//  Bookworm
//
//  Created by Martí Espinosa Farran on 28/7/24.
//

import Foundation

class BookSearchManager {
    private let apiKey = "AIzaSyCAKz9nXWuXG5MBeIB1UoPMSpHEQBRFROk"
    
    func getBooks(searchTerm: String, completion: @escaping (Books?) -> Void) {
        let sessionConfig = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)

        guard var URL = URL(string: "https://www.googleapis.com/books/v1/volumes") else {
            print("Invalid URL")
            completion(nil)
            return
        }

        let URLParams = [
            "q": "\(searchTerm)",
        ]
        URL = URL.appendingQueryParameters(URLParams)
        var request = URLRequest(url: URL)
        request.httpMethod = "GET"

        let task = session.dataTask(with: request, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) -> Void in
            if let error = error {
                print("URL Session Task Failed: \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                print("HTTP Request failed")
                completion(nil)
                return
            }

            guard let jsonData = data else {
                print("No data received")
                completion(nil)
                return
            }
            
            do {
                let bookData = try JSONDecoder().decode(Books.self, from: jsonData)
                completion(bookData)
            } catch {
                print("JSON Decoding error: \(error)")
                completion(nil)
            }
        })
        task.resume()
    }
    
    func getPopularBooks(completion: @escaping (Books?) -> Void) {
        let sessionConfig = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)

        guard var URL = URL(string: "https://www.googleapis.com/books/v1/volumes") else {
            print("Invalid URL")
            completion(nil)
            return
        }

        let URLParams = [
            "q": "*",
            "orderBy": "relevance",
        ]
        URL = URL.appendingQueryParameters(URLParams)
        var request = URLRequest(url: URL)
        request.httpMethod = "GET"

        let task = session.dataTask(with: request, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) -> Void in
            if let error = error {
                print("URL Session Task Failed: \(error.localizedDescription)")
                completion(nil)
                return
            }

            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                print("HTTP Request failed with status code: \((response as? HTTPURLResponse)?.statusCode ?? -1)")
                completion(nil)
                return
            }

            guard let jsonData = data else {
                print("No data received")
                completion(nil)
                return
            }
            
            do {
                let bookData = try JSONDecoder().decode(Books.self, from: jsonData)
                completion(bookData)
            } catch {
                print("JSON Decoding error: \(error)")
                completion(nil)
            }
        })
        task.resume()
    }
}

protocol URLQueryParameterStringConvertible {
    var queryParameters: String {get}
}

extension Dictionary : URLQueryParameterStringConvertible {
    var queryParameters: String {
        var parts: [String] = []
        for (key, value) in self {
            let part = String(format: "%@=%@",
                              String(describing: key).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!,
                              String(describing: value).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
            parts.append(part)
        }
        return parts.joined(separator: "&")
    }
}

extension URL {
    func appendingQueryParameters(_ parametersDictionary : Dictionary<String, String>) -> URL {
        let URLString : String = String(format: "%@?%@", self.absoluteString, parametersDictionary.queryParameters)
        return URL(string: URLString)!
    }
}
