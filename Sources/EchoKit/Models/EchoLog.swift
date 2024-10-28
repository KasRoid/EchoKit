//
//  EchoLog.swift
//  EchoKit
//
//  Created by Lukas on 10/25/24.
//

import Foundation

public struct EchoLog {
    
    public static func urlRequest(request: URLRequest?, metrics: URLSessionTaskMetrics?) -> String {
        let url = request?.url?.absoluteString ?? "Unknown"
        let method = request?.httpMethod ?? "Unknown"
        let requestSize = request?.httpBody?.count ?? 0
        let requestDuration = metrics?.taskInterval.duration ?? 0.0
        let queryParams = request?.url?.query ?? "None"
        
        let headers = request?.allHTTPHeaderFields?.map { "\($0.key): \($0.value)" } ?? []
        let headersString = headers.joined(separator: "\n")
        let requestBody = request?.httpBody.flatMap { try? JSONSerialization.jsonObject(with: $0, options: []) } as? [String: Any]
        let prettyRequestBody = requestBody?.prettyJSON ?? "Unknown"
        
        let logMessage = """
            ===== Request Summary =====
            URL: \(url)
            Method: \(method)
            Date: \(Date())
            Request Size: \(requestSize) bytes
            Duration: \(String(format: "%.2f", requestDuration)) seconds
            Query Parameters: \(queryParams)
            
            ----- Headers -----
            \(headersString)
            
            ----- Body -----
            \(prettyRequestBody)
            
            ============================
            
            """
        return logMessage
    }
    
    public static func urlResponse(response: URLResponse?, metrics: URLSessionTaskMetrics?, data: Data?, error: Error?) -> String {
        let url = response?.url?.absoluteString ?? "Unknown"
        let statusCode = (response as? HTTPURLResponse)?.statusCode ?? 0
        let responseSize = data?.count ?? 0
        let responseDuration = metrics?.taskInterval.duration ?? 0.0
        let errorMessage = error?.localizedDescription ?? "None"
        
        let headers = (response as? HTTPURLResponse)?.allHeaderFields.map { "\($0.key): \($0.value)" } ?? []
        let headersString = headers.joined(separator: "\n")
        let responseBody = data.flatMap { try? JSONSerialization.jsonObject(with: $0, options: []) } as? [String: Any]
        let prettyResponseBody = responseBody?.prettyJSON ?? "Unknown"
        
        let logMessage = """
            ===== Response Summary =====
            URL: \(url)
            Status: \(statusCode)
            Date: \(Date())
            Response Size: \(responseSize) bytes
            Duration: \(String(format: "%.2f", responseDuration)) seconds
            Error: \(errorMessage)
            
            ----- Headers -----
            \(headersString)
            
            ----- Body -----
            \(prettyResponseBody)
            
            ============================
            
            """
        return logMessage
    }
    
    public static func performance(task: String, duration: TimeInterval) -> String {
        let logMessage = """
            ===== Performance Log =====
            Task: \(task)
            Duration: \(String(format: "%.6f", duration)) seconds
            
            ============================
            """
        return logMessage
    }
    
    public static func error(error: Error) -> String {
        let timestamp = Date()
        let logMessage = """
            ===== Error Log =====
            Reason: \(error.localizedDescription)
            Description: \(error)
            
            ============================
            """
        return logMessage
    }
}
