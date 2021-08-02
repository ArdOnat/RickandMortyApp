//
//  NetworkRouter.swift
//  ArdaOnatOBSSCase
//
//  Created by Arda Onat on 17.07.2021.
//

import Alamofire
import Foundation

typealias HTTPHeaders = [String: String]
typealias Parameters = [String: Any]

enum HTTPMethods {
    case GET
    case POST
    
    var AFHTTPMethod: HTTPMethod {
        switch self {
        case .GET:
            return .get
        default:
            return .post
        }
    }
}

protocol Request {
    var baseURL: URL { get }
    var path: String { get }
    var httpMethod: HTTPMethods { get }
    var urlParameters: Parameters? { get }
    var bodyParameters: Parameters? { get }
    var httpHeaders: HTTPHeaders? { get }
}

struct NetworkLayer {
    
    static let shared: NetworkLayer = NetworkLayer()
    
    /// Function to make a request with EndPoint parameter.
    /// - Parameters:
    ///   - request: Request object  that includes values that are needed to make a request  such as url, parameters, headers.
    ///   - queue: Parameter for making concurrent requests. Default value is set as main thread.
    ///   - completion: Completion block that will be executed after request is completed. Success failure cases of the service will be handled in this completion block.
    func request<T: Decodable>(_ request: Request, queue: DispatchQueue = DispatchQueue.main, completion: @escaping (Result<T, NetworkError>) -> ()) {
        guard let request = try? self.buildRequest(from: request) else {
            return completion(.failure(.invalidRequest))
        }
        
        AF.request(request).validate().responseDecodable(of: T.self) { response in
            switch response.result {
            case .success(let decodableResult):
                completion(.success(decodableResult))
            case .failure(_):
                completion(.failure(.invalidStatusCode))
            }
        }
    }
    
    /// Function to make a request with full request URL.
    /// - Parameters:
    ///   - requestURL: Full request URL.
    ///   - queue: Parameter for making concurrent requests. Default value is set as main thread.
    ///   - completion: Completion block that will be executed after request is completed. Success failure cases of the service will be handled in this completion block.
    func request<T: Decodable>(requestURL: URL, queue: DispatchQueue = DispatchQueue.main, completion: @escaping (Result<T, NetworkError>) -> ()) {
        AF.request(requestURL).responseDecodable(of: T.self) { response in
            switch response.result {
            case .success(let decodableResult):
                completion(.success(decodableResult))
            case .failure(_):
                completion(.failure(.invalidStatusCode))
            }
        }
    }
    
    /// Function to make request and get a json response that needs to be dcoded to the generic type T.
    /// - Parameters:
    ///   - request: Request object  that includes values that are needed to make a request  such as url, parameters, headers.
    ///   - queue: Parameter for making concurrent requests. Default value is set as main thread.
    ///   - completion: Completion block that will be executed after request is completed. Success failure cases of the service will be handled in this completion block.
    func requestJSON<T: Decodable>(_ request: Request, queue: DispatchQueue = DispatchQueue.main, completion: @escaping (Result<T, NetworkError>) -> ()) {
        guard let request = try? self.buildRequest(from: request) else {
            return completion(.failure(.invalidRequest))
        }
        
        AF.request(request).validate().response(queue: queue) { response in
            switch response.result {
                case .success(let json):
                    guard let json = json, let data = try? JSONDecoder().decode(T.self, from: json) else {
                        completion(.failure(.decodingFailed))
                        return
                    }
                    completion(.success(data))

                case .failure(_):
                    completion(.failure(.invalidStatusCode))
            }
        }
    }
    
    fileprivate func buildRequest(from requestToMake: Request) throws -> URLRequest {
        var request = URLRequest(url: requestToMake.baseURL.appendingPathComponent(requestToMake.path), cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 10.0)
        request.httpMethod = requestToMake.httpMethod.AFHTTPMethod.rawValue
       
        do {
            if let additionalHeaders = requestToMake.httpHeaders {
                self.addAdditionalHeaders(additionalHeaders, request: &request)
            }
            try self.configureParameters(bodyParameters: requestToMake.bodyParameters, urlParameters: requestToMake.urlParameters, request: &request)
            return request
        } catch {
            throw error
        }
    }
    
    fileprivate func configureParameters(bodyParameters: Parameters?, urlParameters: Parameters?, request: inout URLRequest) throws {
        do {
            if let bodyParameters = bodyParameters {
                try JSONParameterEncoder.encode(urlRequest: &request, with: bodyParameters)
            }
            
            if let urlParameters = urlParameters {
                try URLParameterEncoder.encode(urlRequest: &request, with: urlParameters)
            }
        } catch {
            throw error
        }
    }
    
    fileprivate func addAdditionalHeaders(_ additionalHeaders: HTTPHeaders?, request: inout URLRequest) {
        guard let headers = additionalHeaders else { return }
        for (key, value) in headers {
            request.setValue(value, forHTTPHeaderField: key)
        }
    }
    
}
