//
//  AhoyAPI.swift
//  Ahoy
//
//  Created by Ben Garcia on 4/8/21.
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

class APIError: Error, CustomStringConvertible {
    
    let message: String
    
    var description: String {
        return self.message
    }
    
    init(message: String) {
        self.message = message
    }
}

class AhoyAPI {
    
    static let shared = AhoyAPI()
    private static let host = "http://10.55.8.119"
    
    private class RequestInfo {
        let url: URL
        let method: HTTPMethod
        let headers: [String: String]
        let body: [String: Any]?
        
        init?(urlString: String, method: HTTPMethod, queryParameters: [String: String]?, headers: [String: String]?, body: [String: Any]?) {
            
            guard var urlComponents = URLComponents(string: urlString) else { return nil}
            
            if let queryParameters = queryParameters {
                urlComponents.queryItems = queryParameters.map({ key, value in
                    return URLQueryItem(name: key, value: value)
                })
            }
            
            guard let url = urlComponents.url else { return nil }
            
            self.url = url
            self.method = method
            self.headers = headers ?? [String: String]()
            self.body = body
        }
    }
    
    public func createPost(author: String, content: String, success: @escaping (Post) -> Void, failure: @escaping (Error) -> Void) {
        
        guard let request = RequestInfo(urlString: "\(AhoyAPI.host)/api/posts", method: .post, queryParameters: nil, headers: nil, body: [ "author": author, "content": content ]) else {
            failure(APIError(message: "Invalid request."))
            return
        }
        
        self.sendRequest(request, success: { data, statusCode in
            if let data = data as? [String: Any], let post = Post(dictionary: data) {
                success(post)
            } else {
                failure(APIError(message: "Couldn't decode post."))
            }
        }, failure: failure)
    }
    
    private func sendRequest(_ request: RequestInfo, success: @escaping (Any?, Int) -> Void, failure: @escaping (Error) -> Void) {
        
        var urlRequest = URLRequest(url: request.url)
        urlRequest.httpMethod = request.method.rawValue
        
        // If there is a body to send, attach it
        if let body = request.body {
            urlRequest.httpBody = try? JSONSerialization.data(withJSONObject: body, options: .prettyPrinted)
            urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        
        // TODO: Add custom headers
        
        let task = URLSession.shared.dataTask(with: urlRequest, completionHandler: { data, response, error in
            
            // If there was an error, fail
            if let error = error {
                failure(error)
            }
            
            if let response = response as? HTTPURLResponse {
                if let data = data {
                    if let responseObject = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                        if let isSuccess = responseObject["success"] as? Bool, isSuccess, let data = responseObject["data"] {
                            success(data, response.statusCode)
                        } else if let message = responseObject["message"] as? String {
                            failure(APIError(message: message))
                        } else {
                            failure(APIError(message: "Invalid response from server!"))
                        }
                    } else {
                        failure(APIError(message: "Invalid response from server!"))
                    }
                } else {
                    success(nil, response.statusCode)
                }
            } else {
                failure(APIError(message: "Invalid response!"))
            }
        })
        
        task.resume()
    }
}
