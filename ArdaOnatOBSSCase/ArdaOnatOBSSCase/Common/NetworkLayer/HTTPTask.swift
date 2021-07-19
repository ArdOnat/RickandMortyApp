//
//  HTTPTask.swift
//  ArdaOnatOBSSCase
//
//  Created by Arda Onat on 17.07.2021.
//

import Foundation

enum HTTPTask {
    case request
    
    case requestParamaters(bodyParameters: Parameters? = nil, urlParameters: Parameters? = nil)
    
    case requestParametersAndHeaders(bodyParameters: Parameters? = nil, urlParameters: Parameters? = nil, additionHeaders: HTTPHeaders)
}
