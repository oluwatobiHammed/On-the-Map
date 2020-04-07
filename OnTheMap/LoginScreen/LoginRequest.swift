//
//  LoginRequest.swift
//  OnTheMap
//
//  Created by user on 06/04/2020.
//  Copyright © 2020 Anastasia Petrova. All rights reserved.
//

import Foundation
struct LoginRequest: Codable {
    let username: String
    let password: String
    
    enum CodingKeys: String, CodingKey {
        case username
        case password
    }
}
