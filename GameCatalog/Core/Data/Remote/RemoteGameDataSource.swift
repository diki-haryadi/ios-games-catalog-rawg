//
//  RemoteGameDataSource.swift
//  GameCatalog
//
//  Created on 03/04/25.
//

import Foundation
import Combine
import Alamofire

protocol RemoteGameDataSourceProtocol {
  func getGames() -> AnyPublisher<[GameModel], Error>
  func getGameDetail(id: Int) -> AnyPublisher<GameModel, Error>
  func searchGames(query: String) -> AnyPublisher<[GameModel], Error>
}

// Define a custom error enum for cleaner error handling
enum NetworkError: Error {
    case invalidURL
    case decodingError
    case serverError
    case noData
    case emptyQuery
}

// Network Logger for Alamofire
class NetworkLogger: EventMonitor {
    let queue = DispatchQueue(label: "com.GameCatalog.networklogger")
    
    // Log when a request starts
    func requestDidResume(_ request: Request) {
        print("REQUEST STARTED: \(request.description)")
        
        // Log headers
        if let headers = request.request?.allHTTPHeaderFields, !headers.isEmpty {
            print("Headers: \(headers)")
        }
        
        // Log HTTP body if present
        if let httpBody = request.request?.httpBody, let bodyString = String(data: httpBody, encoding: .utf8) {
            print("Body: \(bodyString)")
        }
    }
    
    // Log when a request finishes
    func request<Value>(_ request: DataRequest, didParseResponse response: DataResponse<Value, AFError>) {
        print("\n RESPONSE RECEIVED: \(request.description)")
        
        // Log status code
        if let statusCode = response.response?.statusCode {
            let emojiStatus = statusCode >= 200 && statusCode < 300 ? "✅" : "❌"
            print("\(emojiStatus) Status Code: \(statusCode)")
        }
        
        // Log headers
        if let headers = response.response?.allHeaderFields {
//            print("Response Headers: \(headers)")
        }
        
        // Log the response data
        switch response.result {
        case .success:
            if let data = response.data, !data.isEmpty {
//                print("original data")
//                print(data)
                if let json = try? JSONSerialization.jsonObject(with: data),
                   let prettyData = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted),
                   let prettyString = String(data: prettyData, encoding: .utf8) {
                    // Truncate large responses for readability
//                    print("original data: \(prettyString)")
                    let truncated = prettyString.count > 1000 ? prettyString.prefix(1000) + "...(truncated)" : prettyString
//                    print("Response Data: \(truncated)")
                } else if let string = String(data: data, encoding: .utf8) {
                    let truncated = string.count > 500 ? string.prefix(500) + "...(truncated)" : string
                    print("Response Data (not JSON): \(truncated)")
                }
            } else {
                print("esponse Data: Empty")
            }
        case .failure(let error):
            print("Response Error: \(error.localizedDescription)")
            if let responseData = response.data, let string = String(data: responseData, encoding: .utf8) {
                print("Error Response Data: \(string)")
            }
        }
        
        print("Request Duration: \(String(format: "%.2f", request.metrics?.taskInterval.duration ?? 0)) seconds")
        print("Request Completed: \(Date())\n")
    }
    
    // Log request retries
    func request(_ request: Request, didRetrieveCachedResponse response: CachedURLResponse) {
        print("Retrieved response from cache for: \(request)")
    }
    
    // Log errors
    func request(_ request: Request, didFailToCreateURLRequestWithError error: AFError) {
        print("Failed to create request: \(error)")
    }
    
    func request(_ request: Request, didFailTask task: URLSessionTask, earlyWithError error: AFError) {
        print("Request \(request) failed early with error: \(error)")
    }
    
    func request(_ request: Request, didFailToValidateResponse response: HTTPURLResponse, data: Data?, withError error: AFError) {
        print("Request \(request) failed validation with error: \(error)")
    }
}

final class RemoteGameDataSource: NSObject {
  
  private override init() {
    // Initialize Alamofire session with the logger
    let configuration = URLSessionConfiguration.default
    configuration.timeoutIntervalForRequest = 30
    
    // Create the Alamofire session with our logger
    session = Session(configuration: configuration, eventMonitors: [NetworkLogger()])
    
    super.init()
  }
  
  static let sharedInstance: RemoteGameDataSource = RemoteGameDataSource()
  
  // Use the API values from APICall.swift instead of hardcoding
  private let baseUrl = API.gameBaseUrl
  private let apiKey = API.gameApiKey
  
  // Alamofire session
  private let session: Session
  
  // Create a JSON decoder with custom strategies for snake_case to camelCase conversion
  private lazy var decoder: JSONDecoder = {
    let decoder = JSONDecoder()
    decoder.keyDecodingStrategy = .convertFromSnakeCase
    return decoder
  }()
  
  // Creates standard headers for API requests
  private var standardHeaders: HTTPHeaders {
    return [
        "Content-Type": "application/json",
        "Accept": "application/json"
    ]
  }
}

extension RemoteGameDataSource: RemoteGameDataSourceProtocol {
  
  func getGames() -> AnyPublisher<[GameModel], Error> {
    // Use the endpoint from Endpoints enum
    guard let url = URL(string: Endpoints.Gets.games.url) else {
        return Fail(error: NetworkError.invalidURL).eraseToAnyPublisher()
    }
    
    print("Requesting games from URL: \(Endpoints.Gets.games.url)")
    
    return session.request(
        url,
        method: .get,
        headers: standardHeaders
    )
    .validate()
    .publishData()
    .tryMap { response -> Data in
        print("Response status code: \(response.response?.statusCode ?? 0)")
        
        guard let data = response.data, !data.isEmpty else {
            print("Response contains no data")
            throw NetworkError.noData
        }
        
        // Debug: Print sample of response for verification
        if let responseString = String(data: data, encoding: .utf8) {
            if !responseString.contains("\"results\"") {
                print("Warning: Response does not contain 'results' key")
                print("Full Response: \(responseString)")
            }
        }
        
        return data
    }
    .decode(type: GamesListResponse.self, decoder: JSONDecoder())
    .map { response in
        print("Successfully decoded response with \(response.results.count) games")
           if let firstGame = response.results.first {
               print("First game details:")
               print("- ID: \(firstGame.id)")
               print("- Name: \(firstGame.name)")
               print("- Background Image: \(firstGame.backgroundImage ?? "nil")")
               // Print other properties as needed
               
               // Introspect the object to see all available properties
               let mirror = Mirror(reflecting: firstGame)
               print("All properties in first game:")
               for (label, value) in mirror.children {
                   print("  \(label ?? "unknown"): \(value)")
               }
           }
        return GameMapper.mapGameResponsesToDomainModels(input: response.results)
    }
    .mapError { error -> Error in
        self.handleNetworkError(error, operation: "Get Games")
    }
    .eraseToAnyPublisher()
  }
  
  func getGameDetail(id: Int) -> AnyPublisher<GameModel, Error> {
    guard let url = URL(string: Endpoints.Gets.gameDetail(id: id).url) else {
        return Fail(error: NetworkError.invalidURL).eraseToAnyPublisher()
    }
    
    print("Requesting game detail for ID \(id) from URL: \(url.absoluteString)")
    
    return session.request(
        url,
        method: .get,
        headers: standardHeaders
    )
    .validate()
    .publishData()
    .tryMap { response -> Data in
        print("Response status code: \(response.response?.statusCode ?? 0)")
        
        guard let data = response.data, !data.isEmpty else {
            print("Response contains no data")
            throw NetworkError.noData
        }
        
        return data
    }
    .decode(type: GameDetailResponse.self, decoder: JSONDecoder())
    .map { response in
        print("Successfully decoded game detail for ID \(id)")
        return GameMapper.mapDetailResponseToDomainModel(input: response)
    }
    .mapError { error -> Error in
        self.handleNetworkError(error, operation: "Get Game Detail")
    }
    .eraseToAnyPublisher()
  }
  
  func searchGames(query: String) -> AnyPublisher<[GameModel], Error> {
    // Ensure the query isn't empty
    let trimmedQuery = query.trimmingCharacters(in: .whitespacesAndNewlines)
    guard !trimmedQuery.isEmpty else {
        print("Search query is empty")
        return Fail(error: NetworkError.emptyQuery).eraseToAnyPublisher()
    }
    
    // URL encode the search query for safety
    guard let encodedQuery = trimmedQuery.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
        return Fail(error: NetworkError.invalidURL).eraseToAnyPublisher()
    }
    
    // Create the base URL
    guard let url = URL(string: API.gameBaseUrl + "games") else {
        return Fail(error: NetworkError.invalidURL).eraseToAnyPublisher()
    }
    
    // Prepare parameters with proper encoding
    let parameters: [String: Any] = [
        "key": API.gameApiKey,
        "search": encodedQuery,
        "page_size": 20  // Limit results for better performance
    ]
    
    print("🔍 Searching games with query: '\(trimmedQuery)'")
    
    return session.request(
        url,
        method: .get,
        parameters: parameters,
        encoding: URLEncoding.queryString,  // Ensures proper URL parameter formatting
        headers: standardHeaders
    )
    .validate()
    .publishData()
    .tryMap { response -> Data in
        print("Search response status code: \(response.response?.statusCode ?? 0)")
        
        guard let data = response.data, !data.isEmpty else {
            print("Search response contains no data")
            throw NetworkError.noData
        }
        
        return data
    }
    .decode(type: GamesListResponse.self, decoder: JSONDecoder())
    .map { response in
        print("Successfully decoded search response with \(response.results.count) results")
        return GameMapper.mapGameResponsesToDomainModels(input: response.results)
    }
    .mapError { error -> Error in
        self.handleNetworkError(error, operation: "Search Games")
    }
    .eraseToAnyPublisher()
  }
  
  // Helper method to standardize error handling across all request types
  private func handleNetworkError(_ error: Error, operation: String) -> Error {
    if let afError = error as? AFError {
        print("\(operation) - Alamofire Error: \(afError.localizedDescription)")
        
        if let underlyingError = afError.underlyingError {
            print("  └ Underlying error: \(underlyingError)")
        }
        
        if let responseCode = afError.responseCode {
            print("  └ Response code: \(responseCode)")
        }
        
        return NetworkError.serverError
    } else if let decodingError = error as? DecodingError {
        print("\(operation) - Decoding Error: \(decodingError)")
        
        // Provide detailed context for decoding errors
        switch decodingError {
        case .keyNotFound(let key, let context):
            print("  └ Missing key: \(key.stringValue)")
            print("  └ Context: \(context.debugDescription)")
            print("  └ Coding path: \(context.codingPath.map { $0.stringValue })")
        case .typeMismatch(let type, let context):
            print("  └ Type mismatch: expected \(type)")
            print("  └ Context: \(context.debugDescription)")
            print("  └ Coding path: \(context.codingPath.map { $0.stringValue })")
        case .valueNotFound(let type, let context):
            print("  └ Value missing: expected \(type)")
            print("  └ Context: \(context.debugDescription)")
        case .dataCorrupted(let context):
            print("  └ Data corrupted: \(context.debugDescription)")
        @unknown default:
            print("  └ Unknown decoding error")
        }
        
        return NetworkError.decodingError
    }
    
    print("\(operation) - Unknown Error: \(error.localizedDescription)")
    return error
  }
}
