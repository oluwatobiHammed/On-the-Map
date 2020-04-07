//
//  LocationRequest.swift
//  OnTheMap
//
//  Created by Oladipupo Oluwatobi on 28/03/2020.
//  Copyright © 2020 Oladipupo Oluwatobi. All rights reserved.
//

import Foundation

struct LocationRequest: Encodable {
    let uniqueKey: String
    let firstName: String
    let lastName: String
    let mapString: String
    let mediaURL: String
    let latitude: Double
    let longitude: Double
}
