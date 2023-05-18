//
//  Log.swift
//  The GlassRoom
//
//  Created by Kai Quan Tay on 18/5/23.
//

import SwiftUI

public class Log: ObservableObject {
    public static var global: Log = .init()

    @Published public var logHistory: [LogEntry] = []

    private init() {}

    public struct LogEntry: Identifiable, Hashable {
        public var id = UUID()
        public var type: LogType
        public var content: String
        public var file: String
        public var line: Int

        public enum LogType {
            case info
            case error
        }
    }

    public static func info(_ content: Any, file: String = #file, line: Int = #line) {
        Log.global.info(content: content, file: file, line: line)
        print("[INFO \(file):\(line)]: \(content)")
    }

    public static func error(_ content: Any, file: String = #file, line: Int = #line) {
        Log.global.error(content: content, file: file, line: line)
        print("[ERROR \(file):\(line)]: \(content)")
    }

    private func info(content: Any, file: String, line: Int) {
        logHistory.append(.init(type: .info,
                                content: "\(content)",
                                file: file,
                                line: line))
    }

    private func error(content: Any, file: String, line: Int) {
        logHistory.append(.init(type: .error,
                                content: "\(content)",
                                file: file,
                                line: line))
    }
}


