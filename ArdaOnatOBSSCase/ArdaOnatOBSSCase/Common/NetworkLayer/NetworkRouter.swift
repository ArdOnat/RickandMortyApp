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

protocol EndPoint {
    var baseURL: URL { get }
    var path: String { get }
    var httpMethod: HTTPMethod { get }
    var task: HTTPTask { get }
    var headers: HTTPHeaders? { get }
}

enum NetworkEnvironment {
    case production
}

enum EndPoints: EndPoint {
    case fetchCharacters(page: Int, searchTerm: String?, status: CharacterStatus?)
    
    var environmentBaseURL : String {
        switch NetworkLayer.environment {
        case .production: return "https://rickandmortyapi.com/api/"
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
    
    var task: HTTPTask {
        switch self {
        case .fetchCharacters(let page, let searchTerm, let status):
            var urlParameters = [String: Any]()
            
            urlParameters["page"] = page
            
            if let searchTerm = searchTerm {
                urlParameters["name"] = searchTerm
            }
            
            if let status = status {
                urlParameters["status"] = status.parameterValue
            }
            return .requestParamaters(urlParameters: urlParameters)
        }
    }
    
    var headers: HTTPHeaders? {
        return nil
    }
}


protocol NetworkRouter {
    func request<T: Decodable>(_ route: EndPoint, completion: @escaping (AFResult<T>) -> ())
}

struct NetworkLayer: NetworkRouter {
    
    static let environment : NetworkEnvironment = .production

    func request<T: Decodable>(_ route: EndPoint, completion: @escaping (AFResult<T>) -> ()){
        guard let request = try? self.buildRequest(from: route) else {
            return completion(.failure(.explicitlyCancelled))
        }
        
        AF.request(request).validate().responseDecodable(of: T.self) { response in
            completion(response.result)
        }
    }
    
    fileprivate func buildRequest(from route: EndPoint) throws -> URLRequest {
        var request = URLRequest(url: route.baseURL.appendingPathComponent(route.path), cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 10.0)
        request.httpMethod = route.httpMethod.rawValue
        
        do {
            switch route.task {
            case .request:
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            case .requestParamaters(let bodyParameters, let urlParameters):
                try self.configureParameters(bodyParameters: bodyParameters, urlParameters: urlParameters, request: &request)
                
            case .requestParametersAndHeaders(bodyParameters: let bodyParameters, urlParameters: let urlParameters, let additionalHeaders):
                self.addAdditionalHeaders(additionalHeaders, request: &request)
                try self.configureParameters(bodyParameters: bodyParameters, urlParameters: urlParameters, request: &request)
            }
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
