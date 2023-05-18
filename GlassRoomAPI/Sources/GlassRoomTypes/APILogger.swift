//
//  APILogger.swift
//  
//
//  Created by Kai Quan Tay on 18/5/23.
//

import Foundation

public enum APISecretManager {
    public static var accessToken: String = ""
}

public class APILogger: ObservableObject {
    @Published public private(set) var apiHistory: [APICall] = []

    public func add(item: APICall) {
        DispatchQueue.main.async {
            self.apiHistory.append(item)
        }
    }

    private init() {}
    public static var global: APILogger = .init()

    public struct APICall: Hashable, Identifiable {
        public var id = UUID()

        public var requestType: String
        public var requestUrl: String
        public var parameters: [String: String]
        public var expectedResponseType: String
        public var sendDate: Date = Date()

        public init(id: UUID = UUID(),
                    requestType: String, 
                    requestUrl: String, 
                    parameters: [String : String], 
                    expectedResponseType: String,
                    sendDate: Date = Date()) {
            self.id = id
            self.requestType = requestType
            self.requestUrl = requestUrl
            self.parameters = parameters
            self.expectedResponseType = expectedResponseType
            self.sendDate = sendDate
        }
    }
}
