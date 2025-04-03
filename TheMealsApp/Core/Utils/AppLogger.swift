//
//  AppLogger.swift
//  TheMealsApp
//
//  Created on 03/04/25.
//

import Foundation
import os.log

class AppLogger {
    
    enum Category: String {
        case network = "Network"
        case database = "Database"
        case uiFlow = "UI"
        case general = "General"
    }
    
    static let shared = AppLogger()
    private let subsystem = Bundle.main.bundleIdentifier ?? "com.themealsapp"
    
    private init() {}
    
    func getLogger(category: Category) -> Logger {
        return Logger(subsystem: subsystem, category: category.rawValue)
    }
    
    func getLogger(category: String) -> Logger {
        return Logger(subsystem: subsystem, category: category)
    }
    
    // Network specific logging helpers
    
    static func logRequest(_ request: URLRequest) {
        let logger = AppLogger.shared.getLogger(category: .network)
        
        let method = request.httpMethod ?? "Unknown"
        let url = request.url?.absoluteString ?? "Unknown URL"
        
        var logMessage = "📲 \(method) \(url)"
        
        if let headers = request.allHTTPHeaderFields, !headers.isEmpty {
            logMessage += "\nHeaders: \(headers)"
        }
        
        if let body = request.httpBody, let bodyString = String(data: body, encoding: .utf8) {
            let truncatedBody = bodyString.count > 500 ? bodyString.prefix(500) + "..." : bodyString
            logMessage += "\nBody: \(truncatedBody)"
        }
        
        logger.info("\(logMessage)")
    }
    
    static func logResponse(data: Data?, response: URLResponse?, error: Error?) {
        let logger = AppLogger.shared.getLogger(category: .network)
        
        if let error = error {
            logger.error("❌ Network error: \(error.localizedDescription)")
            return
        }
        
        guard let httpResponse = response as? HTTPURLResponse else {
            logger.error("❌ Invalid response type")
            return
        }
        
        let url = httpResponse.url?.absoluteString ?? "Unknown URL"
        let statusCode = httpResponse.statusCode
        
        var logMessage = "📱 Response: \(statusCode) for \(url)"
        
        if let data = data, !data.isEmpty, statusCode != 204 /* No Content */ {
            if let json = try? JSONSerialization.jsonObject(with: data, options: []),
               let jsonData = try? JSONSerialization.data(withJSONObject: json, options: [.prettyPrinted]),
               let jsonString = String(data: jsonData, encoding: .utf8) {
                
                let truncatedJson = jsonString.count > 1000 ? jsonString.prefix(1000) + "..." : jsonString
                logMessage += "\nResponse Body: \(truncatedJson)"
            } else if let string = String(data: data, encoding: .utf8) {
                let truncatedString = string.count > 500 ? string.prefix(500) + "..." : string
                logMessage += "\nResponse Body: \(truncatedString)"
            } else {
                logMessage += "\nResponse Body: Binary data of \(data.count) bytes"
            }
        }
        
        if (200...299).contains(statusCode) {
            logger.info("\(logMessage)")
        } else {
            logger.error("\(logMessage)")
        }
    }
    
    // Common error types
    
    static func logDecodeError(_ error: DecodingError, context: String = "") {
        let logger = AppLogger.shared.getLogger(category: .network)
        let contextPrefix = context.isEmpty ? "" : "[\(context)] "
        
        switch error {
        case .dataCorrupted(let context):
            logger.error("❌ \(contextPrefix)Decoding error - corrupted data: \(context.debugDescription)")
            
        case .keyNotFound(let key, let context):
            logger.error("❌ \(contextPrefix)Decoding error - key not found: \(key.stringValue), at path: \(context.codingPath.map { $0.stringValue }.joined(separator: "."))")
            
        case .typeMismatch(let type, let context):
            logger.error("❌ \(contextPrefix)Decoding error - type mismatch: expected \(type), at path: \(context.codingPath.map { $0.stringValue }.joined(separator: "."))")
            
        case .valueNotFound(let type, let context):
            logger.error("❌ \(contextPrefix)Decoding error - value not found: expected \(type), at path: \(context.codingPath.map { $0.stringValue }.joined(separator: "."))")
            
        @unknown default:
            logger.error("❌ \(contextPrefix)Unknown decoding error: \(error.localizedDescription)")
        }
    }
}
