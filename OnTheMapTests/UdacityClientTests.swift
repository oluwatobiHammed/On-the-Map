//
//  UdacityClientTests.swift
//  UdacityClientTests
//
//  Created by Oladipupo Oluwatobi on 28/03/2020.
//  Copyright © 2020 Oladipupo Oluwatobi. All rights reserved.
//

import XCTest
@testable import OnTheMap

final class UdacityClientTests: XCTestCase {

    func test_make_sessionID_request() {
        let sessionIdRequest = UdacityClient.makeSessionIDRequest(username: "Alex", password: "12345")
        XCTAssertEqual(sessionIdRequest.url, URL(string: "https://onthemap-api.udacity.com/v1/session"))
        XCTAssertEqual(sessionIdRequest.httpMethod, "POST")
        XCTAssertEqual(sessionIdRequest.value(forHTTPHeaderField: "Accept"), "application/json")
        XCTAssertEqual(sessionIdRequest.value(forHTTPHeaderField: "Content-Type"), "application/json")
        XCTAssertEqual(sessionIdRequest.httpBody, "{\"udacity\": {\"username\": \"Alex\", \"password\": \"12345\"}}".data(using: .utf8))

    }
    
    func test_make_sessionID_task() {
        let expectedRequest = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/session")!)
        let task = UdacityClient.makeSessionIDTask(request: expectedRequest) { result in
            
        }
        XCTAssertEqual(task.originalRequest, expectedRequest)
    }
    
    func test_make_students_locations_request() {
        let request = UdacityClient.makeStudentsLocationsRequest()
        XCTAssertEqual(request.url, URL(string: "https://onthemap-api.udacity.com/v1/StudentLocation?skip=8386&limit=100&order=createdAt"))
    }
    
    func test_make_students_locations_task() {
        let expectedRequest = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/StudentLocation?skip=8386&limit=100&order=createdAt")!)
        let task = UdacityClient.makeStudentsLocationsTask(
        request: expectedRequest) { result in
            
        }
        XCTAssertEqual(task.originalRequest, expectedRequest)
    }
    
    func test_make_get_user_info_request() {
        let key = "12345"
        let request = UdacityClient.makeGetUserInfoRequest(key: key)
        XCTAssertEqual(request.url, URL(string: "https://onthemap-api.udacity.com/v1/users/\(key)"))
    }
    
    func test_make_get_user_info_task() {
        let expectedRequest = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/session")!)
        let task = UdacityClient.makeGetUserInfoTask(request: expectedRequest)
        XCTAssertEqual(task.originalRequest, expectedRequest)
    }
}
