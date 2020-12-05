//
//  Network.swift
//  ZarinShop
//
//  Created by Murad Ibrohimov on 10/10/20.
//  Copyright © 2020 Murad Ibrohimov. All rights reserved.
//

import Foundation
import Alamofire
import KeychainAccess

typealias Network = ZSNetwork
typealias Success<T> = (_ data: T) -> Void
typealias Failure = (_ error: ZSErrorModel, _ statusCode: Int) -> Void

class ZSNetwork {
    
    // MARK: - constants
    
    static let shared = ZSNetwork()
    static let keychein = Keychain()
    
    // MARK: - Private Variables
    
    private let baseURL = "http://zarinshop.site:49354/api/v1/"
    //private let baseURL = "https://mirllex.site/server/api/v1/"
    private var headers: [String: String] {
        guard let token = ZSNetwork.keychein["service_token"] else { return [:] }
        let headers = ["authorization": "Bearer \(token)"]
        return headers
    }
    
    // MARK: - Initialization
    
    private init() { }
    
    func request<T: Codable>(url: URLPath? = nil,
                             urlStr: String? = nil,
                             method: HTTPMethod,
                             isQueryString: Bool = false,
                             parameters: Parameters? = nil,
                             completion: @escaping (Swift.Result<T, ZSNetworkError>) -> ()) {
        
        var fullPath = self.baseURL
        
        if let url = url {
            fullPath += url.rawValue
        } else if let urlStr = urlStr {
            fullPath += urlStr
        }
        
        guard let url = URL(string: fullPath) else {
            completion(.failure(.unowned("Не верный адресс")))
            return
        }
        
        Alamofire.request(
            url, method: method,
            parameters: parameters,
            encoding: (isQueryString ? URLEncoding.queryString : JSONEncoding.default),
            headers: self.headers)
            .responseData { (response) in
                
                switch (response.result) {
                case .success(let data):
                    guard let code = response.response?.statusCode else { return }
                    switch code {
                    case 200...299:
                        do {
                            let json = try JSONDecoder().decode(T.self, from: data)
                            completion(.success(json))
                        } catch {
                            completion(.failure(.parsing))
                        }
                        return
                    case 401:
                        UserDefaults.standard.setLogoutUser()
                        completion(.failure(.unauthorized))
                        return
                    case 400...500:
                        do {
                            let errorJson = try JSONDecoder().decode(ZSErrorModel.self, from: data)
                            var statusCode = 0
                            if let code = response.response?.statusCode {
                                statusCode = code
                            }
                            completion(.failure(.unowned("\(errorJson.detail)\ncode: \(statusCode)")))
                        } catch {
                            completion(.failure(.parsing))
                        }
                        return
                    default: return
                    }
                case .failure(let error):
                    completion(.failure(.badURL(error)))
                    return
                }
            }

    }
    
    func delete(url: String,
                parameters: Parameters? = nil,
                success: @escaping () -> Void,
                feilure: @escaping (ZSErrorModel) -> Void) {
        
        let fullPath = self.baseURL + url
        guard let url = URL(string: fullPath) else { return }
        
        Alamofire.request(
            url, method: .delete, parameters: parameters,
            encoding: JSONEncoding.default, headers: self.headers)
            .responseData { (response) in
                switch (response.result) {
                case .success(_):
                    guard let code = response.response?.statusCode else { return }
                    switch code {
                    case 200...299:
                        success()
                    case 401:
                        UserDefaults.standard.setLogoutUser()
                        feilure(.init(detail: "Unauthorized"))
                    default:
                        feilure(.init(detail: "Unknowed error"))
                    }
                case .failure(let error):
                    feilure(.init(detail: error.localizedDescription))
                }
        }
    }
    
}
