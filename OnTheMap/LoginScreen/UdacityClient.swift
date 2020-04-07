//
//  UdacityClient.swift
//  OnTheMap
//
//  Created by Oladipupo Oluwatobi on 28/03/2020.
//  Copyright © 2020 Oladipupo Oluwatobi. All rights reserved.
//

import Foundation

final class UdacityClient {
    enum NetworkError: Error {
        case noData
    }
    
    enum Endpoints {
        static let base = "https://onthemap-api.udacity.com/v1"
        
        case getSessionID
        case getStudentsLocations
        case getUserInfo(String)
        case postUserLocation
        case logout
        var stringValue: String {
            switch self {
            case .getSessionID:
                return Endpoints.base
                    + "/session"
            case .getStudentsLocations:
                return Endpoints.base
                    + "/StudentLocation?limit=100&order=-updatedAt"
            case .getUserInfo (let key):
                return Endpoints.base
                    + "/users/\(key)"
            case .postUserLocation:
                return Endpoints.base
                    + "/StudentLocation"
            case .logout:
                return Endpoints.base
                    + "/session"
            }
        }
        var url: URL {
            return URL(string: stringValue)!
        }
    }
    
    class func makeSessionIDRequest(username: String, password: String) -> URLRequest {
        var request = URLRequest(url: URL(string: Endpoints.getSessionID.stringValue)!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = "{\"udacity\": {\"username\": \"\(username)\", \"password\": \"\(password)\"}}".data(using: .utf8)
        return request
    }
    
    class func makeSessionIDTask(
        session: URLSession = .shared,
        request: URLRequest,
        completion: @escaping (Result<RequestSessionIDResponse, Error>) -> Void
    ) -> URLSessionDataTask {
        return session.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = data else {
                completion(.failure(NetworkError.noData))
                return
            }
            do {
                let decoder = JSONDecoder()
                let range = (5..<data.count)
                let newData = data.subdata(in: range)
                let responseObject = try decoder.decode(RequestSessionIDResponse.self, from: newData)
                completion(.success(responseObject))
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    class func performSessionIDRequest(
        username: String,
        password: String,
        completion: @escaping (Result<RequestSessionIDResponse, Error>) -> Void
    ) {
        let request = makeSessionIDRequest(username: username, password: password)
        let task = makeSessionIDTask(request: request, completion: completion)
        
        task.resume()
    }
    
    class func makeStudentsLocationsRequest() -> URLRequest {
        return URLRequest(url: URL(string: Endpoints.getStudentsLocations.stringValue)!)
    }
    
    class func makeStudentsLocationsTask(
        session: URLSession = .shared,
        request: URLRequest,
        completionQueue: DispatchQueue = .main,
        completion: @escaping (Result<Locations, Error>) -> Void) -> URLSessionDataTask {
        return session.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = data else {
                completionQueue.async {
                    completion(.failure(NetworkError.noData))
                }
                return
            }
            let decoder = JSONDecoder()
            do {
                let locations = try decoder.decode(Locations.self, from: data)
                completionQueue.async {
                    completion(.success(locations))
                }
            } catch {
                completionQueue.async {
                    completion(.failure(error))
                }
            }
        }
    }
    
    class func getStudentsLocations(
        completionQueue: DispatchQueue = .main,
        completion: @escaping (Result<Locations, Error>) -> Void
    ) {
        let request = makeStudentsLocationsRequest()
        let task = makeStudentsLocationsTask(
            request: request,
            completionQueue: completionQueue,
            completion: completion)
        
        task.resume()
    }
    
    class func makeGetUserInfoRequest(key: String) -> URLRequest {
        return URLRequest(url: URL(string: Endpoints.getUserInfo(key).stringValue)!)
    }
    
    
    
    
    
    
    class func makeGetUserInfoTask(session: URLSession = .shared, request: URLRequest) -> URLSessionDataTask {
        return session.dataTask(with: request) { data, response, error in
            if error != nil {
                return
            }
            let range = 5..<data!.count
            let newData = data?.subdata(in: range)
            print(String(data: newData!, encoding: .utf8)!)
        }
    }
    
    class func getUserInfo(key: String) {
        let request = makeGetUserInfoRequest(key: key)
        let task = makeGetUserInfoTask(request: request)
        
        task.resume()
    }
    
    class func makePostUserLocationRequest(location: String, link: String, latitude: Double, longitude: Double) -> URLRequest {
        var request = URLRequest(url: URL(string: Endpoints.postUserLocation.stringValue)!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let locationRequest = LocationRequest(
            uniqueKey: UUID().uuidString,
            firstName: "Feodisiy",
            lastName: "Kopytko",
            mapString: location,
            mediaURL: link,
            latitude: latitude,
            longitude: longitude
        )
        request.httpBody = try? JSONEncoder().encode(locationRequest)
        return request
    }
    
    class func makePostUserLocationTask(
        session: URLSession = .shared,
        request: URLRequest,
        completionQueue: DispatchQueue,
        completion: @escaping (Error?) -> Void) -> URLSessionDataTask  {
        return session.dataTask(with: request) { data, response, error in
            completion(error)
            print(String(data: data!, encoding: .utf8)!)
        }
    }
    
    class func postUserLocation(
        location: String,
        link: String,
        latitude: Double,
        longitude: Double,
        completionQueue: DispatchQueue = .main,
        completion: @escaping (Error?) -> Void
    ) {
        let request = makePostUserLocationRequest(
            location: location,
            link: link,
            latitude: latitude,
            longitude: longitude
        )
        let task = makePostUserLocationTask(request: request, completionQueue: completionQueue, completion: completion)
        task.resume()
    }
    
    class func makeLogoutRequest() -> URLRequest {
        var request = URLRequest(url: URL(string: Endpoints.getSessionID.stringValue)!)
        request.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        return request
    }
    
    class func makeLogoutTask(session: URLSession = .shared, request: URLRequest) -> URLSessionDataTask {
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil {
                return
            }
            let range = 5..<data!.count
            let newData = data?.subdata(in: range)
            print(String(data: newData!, encoding: .utf8)!)
        }
        return task
    }
    
    class func logout() {
        let request = makeLogoutRequest()
        let task = makeLogoutTask(request: request)
        task.resume()
    }
}


