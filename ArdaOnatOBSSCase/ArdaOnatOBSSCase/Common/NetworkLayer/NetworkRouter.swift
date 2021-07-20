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

protocol Request {
    var baseURL: URL { get }
    var path: String { get }
    var httpMethod: HTTPMethod { get }
    var urlParameters: Parameters? { get }
    var bodyParameters: Parameters? { get }
    var httpHeaders: HTTPHeaders? { get }
}

enum ServiceRequest: Request {
    case fetchCharacters(page: Int, searchTerm: String?, status: CharacterStatus?)
    
    var environmentBaseURL : String {
        //TODO: Get environment
        switch self {
            case .fetchCharacters(_, _, _): return ApiEnvironment.rickAndMortyApi(environmentType: .production).baseURL
        }
    }
    
    var baseURL: URL {
        guard let url = URL(string: environmentBaseURL) else { fatalError("baseURL could not be configured.")}
        return url
    }
    
    var path: String {
        switch self {
        case .fetchCharacters(_, _, _):
            return "character"
        }
    }
    
    var httpMethod: HTTPMethod {
        return .get
    }
    
    var urlParameters: Parameters? {
        switch self {
        case .fetchCharacters(let page, let searchTerm, let status):
            var urlParameters: Parameters = Parameters()
            urlParameters["page"] = page
            
            if let searchTerm = searchTerm {
                urlParameters["name"] = searchTerm
            }
            
            if let status = status {
                urlParameters["status"] = status.parameterValue
            }
            
            return urlParameters
        }
    }
    
    var bodyParameters: Parameters? {
        return nil
    }
    
    var httpHeaders: HTTPHeaders? {
        return nil
    }
}


protocol NetworkRouterProtocol {
    func request<T: Decodable>(_ request: Request, queue: DispatchQueue, completion: @escaping (AFResult<T>) -> ())
    func request<T: Decodable>(requestURL: URL, queue: DispatchQueue, completion: @escaping (AFResult<T>) -> ())
    func requestJSON<T: Decodable>(_ request: Request, queue: DispatchQueue, completion: @escaping (AFResult<T>) -> ())
}

struct NetworkLayer: NetworkRouterProtocol {
    
    static let shared: NetworkLayer = NetworkLayer()
    
    /// Function to make a request with EndPoint parameter.
    /// - Parameters:
    ///   - request: Request object  that includes values that are needed to make a request  such as url, parameters, headers.
    ///   - queue: Parameter for making concurrent requests. Default value is set as main thread.
    ///   - completion: Completion block that will be executed after request is completed. Success failure cases of the service will be handled in this completion block.
    func request<T: Decodable>(_ request: Request, queue: DispatchQueue = DispatchQueue.main, completion: @escaping (AFResult<T>) -> ()) {
        guard let request = try? self.buildRequest(from: request) else {
            return completion(.failure(.explicitlyCancelled))
        }
        
        AF.request(request).validate().responseDecodable(of: T.self) { response in
            completion(response.result)
        }
    }
    
    /// Function to make a request with full request URL.
    /// - Parameters:
    ///   - requestURL: Full request URL.
    ///   - queue: Parameter for making concurrent requests. Default value is set as main thread.
    ///   - completion: Completion block that will be executed after request is completed. Success failure cases of the service will be handled in this completion block.
    func request<T: Decodable>(requestURL: URL, queue: DispatchQueue = DispatchQueue.main, completion: @escaping (AFResult<T>) -> ()) {
        AF.request(requestURL).validate().responseDecodable(of: T.self) { response in
            completion(response.result)
        }
    }
    
    /// Function to make request and get a json response that needs to be dcoded to the generic type T.
    /// - Parameters:
    ///   - request: Request object  that includes values that are needed to make a request  such as url, parameters, headers.
    ///   - queue: Parameter for making concurrent requests. Default value is set as main thread.
    ///   - completion: Completion block that will be executed after request is completed. Success failure cases of the service will be handled in this completion block.
    func requestJSON<T: Decodable>(_ request: Request, queue: DispatchQueue = DispatchQueue.main, completion: @escaping (AFResult<T>) -> ()) {
        guard let request = try? self.buildRequest(from: request) else {
            return completion(.failure(.explicitlyCancelled))
        }
        
        AF.request(request).validate().response(queue: queue) { response in
            switch response.result {
                case .success(let json):
                    guard let json = json, let data = try? JSONDecoder().decode(T.self, from: json) else {
                        completion(.failure(.responseSerializationFailed(reason: .inputDataNilOrZeroLength)))
                        return
                    }
                    completion(.success(data))

                case .failure(let error):
                    completion(.failure(error))
            }
        }
    }
    
    fileprivate func buildRequest(from requestToMake: Request) throws -> URLRequest {
        var request = URLRequest(url: requestToMake.baseURL.appendingPathComponent(requestToMake.path), cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 10.0)
        request.httpMethod = requestToMake.httpMethod.rawValue
       
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
