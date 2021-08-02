//
//  NetworkError.swift
//  ArdaOnatOBSSCase
//
//  Created by Arda Onat on 17.07.2021.
//

import Foundation

enum NetworkError: String, Error {
    case parametersNil = "Parameters are nil."
    case encodingFailed = "Parameter encoding failed."
    case decodingFailed = "Response decoding failed."
    case missingURL = "URL is nil."
    case invalidRequest = "Request is invalid."
    case invalidStatusCode  = "Status code is invalid."
}
