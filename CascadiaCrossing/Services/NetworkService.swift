// Copyright (c) 2024 PDX Technologies, LLC. All rights reserved.

import Foundation
import Combine

enum NetworkServiceError: Error {
  case invalidURL
  case decodingError(String)
  case genericError(String)
  case invalidResponseCode(Int)
  
  var errorMessageString: String {
    switch self {
    case .invalidURL:
      return "Invalid URL"
    case .decodingError:
      return "Decoding error"
    case .genericError(let message):
      return message
    case .invalidResponseCode(let responseCode):
      return "Invalid response code: \(responseCode)"
    }
  }
}

final class NetworkService {
  let urlSession: URLSession
  let baseURLString: String
  
  init(urlSession: URLSession = .shared, baseURLString: String) {
    self.urlSession = urlSession
    self.baseURLString = baseURLString
  }

  func getPublisherForXMLResponse() -> AnyPublisher<Data, NetworkServiceError> {    
    guard let url = URL(string: baseURLString) else {
      return Fail(error: NetworkServiceError.invalidURL).eraseToAnyPublisher()
    }
    
    return urlSession.dataTaskPublisher(for: url)
      .tryMap { (data, response) -> Data in
        if let httpResponse = response as? HTTPURLResponse {
          guard (200..<300) ~= httpResponse.statusCode else {
            throw NetworkServiceError.invalidResponseCode(httpResponse.statusCode)
          }
        }
        return data
      }
      .mapError { error -> NetworkServiceError in
        if let decodingError = error as? DecodingError {
          return NetworkServiceError.decodingError((decodingError as NSError).debugDescription)
        }
        return NetworkServiceError.genericError(error.localizedDescription)
      }
      .receive(on: DispatchQueue.main)
      .eraseToAnyPublisher()
  }
  
  func getPublisherForResponse<T: Decodable>(endpoint: String, queryParameters: [String: String]) -> AnyPublisher<T, NetworkServiceError> {
    
    let queryItems = queryParameters.map { URLQueryItem(name: $0, value: $1) }
    
    let urlComponents = NSURLComponents(string: baseURLString + endpoint)
    urlComponents?.queryItems = queryItems
    
    guard let url = urlComponents?.url else {
      return Fail(error: NetworkServiceError.invalidURL).eraseToAnyPublisher()
    }
    
    return urlSession.dataTaskPublisher(for: url)
      .tryMap { (data, response) -> Data in
        if let httpResponse = response as? HTTPURLResponse {
          guard (200..<300) ~= httpResponse.statusCode else {
            throw NetworkServiceError.invalidResponseCode(httpResponse.statusCode)
          }
        }
        return data
      }
      .decode(type: T.self, decoder: JSONDecoder())
      .mapError { error -> NetworkServiceError in
        if let decodingError = error as? DecodingError {
          return NetworkServiceError.decodingError((decodingError as NSError).debugDescription)
        }
        return NetworkServiceError.genericError(error.localizedDescription)
      }
      .receive(on: DispatchQueue.main)
      .eraseToAnyPublisher()
  }
  
  func getPublisherForArrayResponse<T: Decodable>(endpoint: String, queryParameters: [String: String]) -> AnyPublisher<[T], NetworkServiceError> {
    let queryItems = queryParameters.map { URLQueryItem(name: $0, value: $1) }
    
    let urlComponents = NSURLComponents(string: baseURLString + endpoint)
    urlComponents?.queryItems = queryItems
    
    guard let url = urlComponents?.url else {
      return Fail(error: NetworkServiceError.invalidURL).eraseToAnyPublisher()
    }
    
    return urlSession.dataTaskPublisher(for: url)
      .tryMap { (data, response) -> Data in
        if let httpResponse = response as? HTTPURLResponse {
          guard (200..<300) ~= httpResponse.statusCode else {
            throw NetworkServiceError.invalidResponseCode(httpResponse.statusCode)
          }
        }
        return data
      }
      .decode(type: [T].self, decoder: JSONDecoder())
      .mapError { error -> NetworkServiceError in
        if let decodingError = error as? DecodingError {
          return NetworkServiceError.decodingError((decodingError as NSError).debugDescription)
        }
        return NetworkServiceError.genericError(error.localizedDescription)
      }
      .eraseToAnyPublisher()
  }
}

