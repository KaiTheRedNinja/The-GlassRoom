//
//  APICaller.swift
//  
//
//  Created by Kai Quan Tay on 11/5/23.
//

import Foundation
import SwiftUI
import GlassRoomTypes

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
        for pathParameter in pathParameters {
            filledURL = filledURL.replacingOccurrences(of: "{\(pathParameter.key)}", with: pathParameter.value)
        }

        // put the query parameters at the end
        filledURL.append("?")
        var mutableQueryParameters = queryParameters
        mutableQueryParameters["access_token"] = APISecretManager.accessToken
        for queryParameter in mutableQueryParameters {
            filledURL.append("\(queryParameter.key)=\(queryParameter.value)&")
        }

        // If there are any empty path parameters, return nil
        if filledURL.contains("/{\\w+}/") {
            Log.error("Filled url contains placeholder: \(filledURL)")
            callback(.failure(NSError(domain: "Filled url contains placeholder: \(filledURL)",
                                      code: 1)))
            return
        }

        // create the URL
        guard let url = URL(string: filledURL) else {
            Log.error("Failed to create url: \(filledURL)")
            callback(.failure(NSError(domain: "Failed to create url: \(filledURL)",
                                      code: 2)))
            return
        }

        // set up the request
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        if let requestData,
           let encodedBody = try? JSONEncoder().encode(requestData),
           String(data: encodedBody, encoding: .utf8) != "{}" {
            request.httpBody = encodedBody
        }

        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: { data, response, error -> Void in
            APILogger.global.add(item: .init(requestType: httpMethod,
                                             requestUrl: urlString,
                                             parameters: pathParameters,
                                             expectedResponseType: String(describing: responseType)))
            if let data {
                do {
                    if ResponseData.self == VoidStringCodable.self,
                       let decodedString = String(data: data, encoding: .utf8),
                       decodedString != "{}" {
                        Log.error("Expected \"{}\", recieved \"\(decodedString)\"")
                    }
                    let result = try JSONDecoder().decode(ResponseData.self, from: data)
                    callback(.success(result))
                } catch {
                    Log.error("""
Decoding error: \(error)
Failure Data: \(String(data: data, encoding: .utf8) ?? "undecodable")
""")
                    callback(.failure(error))
                }
            } else if let error {
                callback(.failure(error))
            }
        })

        task.resume()
    }
}
