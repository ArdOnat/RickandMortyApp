//
//  String+URL.swift
//  ArdaOnatOBSSCase
//
//  Created by Arda Onat on 22.05.2021.
//

import Foundation

extension String {
    var url: URL? {
        guard let url = URL(string: self) else { return nil}
        return url
    }
}
