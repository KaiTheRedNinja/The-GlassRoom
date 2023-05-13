//
//  APICaller.swift
//  
//
//  Created by Kai Quan Tay on 11/5/23.
//

import Foundation

enum APISecretManager {
    static var apiKey: String = ""
}

enum APICaller<ResponseData: Decodable> {
    /// Does an API request
    ///
    /// Usage:
    /// ```
    /// APICaller.request(urlString: "https://your/url/here",
    ///                   httpMethod: "POST",
    ///                   responseType: String.self) { result in
    ///     // handle the result here
    /// }
    /// ```
    /// - Parameters:
    ///   - urlString: The url to request, with path parameters as `{name}` placeholders
    ///   - httpMethod: The HTTP method to use, eg. `GET`, `POST`
    ///   - pathParameters: The path parameters in the URL. Empty by default.
    ///   - queryParameters: The query parameters in the URL (stuff after the ? sign). Empty by default.
    ///   - requestData: The request body, Codable. Empty by default.
    ///   - responseType: The type to decode the response to
    ///   - callback: A callback, called when this method succeeds or fails.
    static func request(
        urlString: String,
        httpMethod: String,
        pathParameters: [String: String] = [:],
        queryParameters: [String: String] = [:],
        requestData: (any Encodable)? = nil,
        responseType: ResponseData.Type,
        callback: @escaping (Result<ResponseData, Error>) -> Void
    ) {
        var filledURL = urlString

        // Replace the url path parameters
        var mutablePathParameters = pathParameters
        mutablePathParameters["access_token"] = APISecretManager.apiKey
        for pathParameter in mutablePathParameters {
            filledURL = filledURL.replacingOccurrences(of: "{\(pathParameter.key)}", with: pathParameter.value)
        }

        // put the query parameters at the end
        if !queryParameters.isEmpty {
            filledURL.append("?")
            for queryParameter in queryParameters {
                filledURL.append("\(queryParameter.key)=\(queryParameter.value)&")
            }
        }

        // If there are any empty path parameters, return nil
        if filledURL.contains("/{\\w+}/") {
            print("Filled url contains placeholder: \(filledURL)")
            callback(.failure(NSError(domain: "Filled url contains placeholder: \(filledURL)",
                                      code: 1)))
            return
        }

        // create the URL
        guard let url = URL(string: filledURL) else {
            print("Failed to create url: \(filledURL)")
            callback(.failure(NSError(domain: "Failed to create url: \(filledURL)",
                                      code: 2)))
            return
        }

        // set up the request
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        if let requestData {
            request.httpBody = try? JSONSerialization.data(withJSONObject: requestData,
                                                           options: [])
        }

        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: { data, response, error -> Void in
            if let data {
                do {
                    let result = try JSONSerialization.jsonObject(with: data) as! ResponseData
                    callback(.success(result))
                } catch {
                    print("Decoding error: \(error)")
                    callback(.failure(error))
                }
            } else if let error {
                callback(.failure(error))
            }
        })

        task.resume()
    }
}
