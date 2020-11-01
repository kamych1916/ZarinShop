//
//  Network.swift
//  ZarinShop
//
//  Created by Murad Ibrohimov on 10/10/20.
//  Copyright © 2020 Murad Ibrohimov. All rights reserved.
//

import Foundation
import Alamofire

typealias Network = ZSNetwork
typealias Success<T> = (_ data: T) -> Void
typealias Failure = (_ error: ZSErrorModel, _ statusCode: Int) -> Void

class ZSNetwork {
    
    // MARK: - constants
    
    static let shared = ZSNetwork()
    
    // MARK: - Private Variables
    
    private let baseURL = "http://zarinshop.site:49354/api/v1/"
    private var headers: [String: String] = [
        "Accept": "*/*",
        "Connection": "keep-alive",
        "Accept-Encoding": "gzip, deflate, br"]
    
    // MARK: - Initialization
    
    private init() { }
    
    func request<T: Decodable>(url: String, method: HTTPMethod,
                               parameters: Parameters? = nil,
                               isQueryString: Bool = false,
                               success: @escaping Success<T>,
                               feilure: Failure? = nil) {
        let fullPath = self.baseURL + url
        guard let url = URL(string: fullPath) else { return }
        print("full path: " + fullPath)
        Alamofire.request(
            url, method: method,
            parameters: parameters,
            encoding: (isQueryString ? URLEncoding.queryString : JSONEncoding.default),
            headers: self.headers)
            .responseData { (response) in
                
                //self.printJson(from: response)
                //self.printBody(from: response)
                
                switch (response.result) {
                case .success(let data):
                    guard let code = response.response?.statusCode else { return }
                    switch code {
                    case 200...299:
                        if let json = try? JSONDecoder().decode(T.self, from: data) {
                            success(json)
                        }
                        break
                    case 401:
                        UserDefaults.standard.setLogoutUser()
                        feilure?(.init(detail: "Не авторизован"), 401)
                        break
                    case 400...500:
                        if let errorJson = try? JSONDecoder().decode(ZSErrorModel.self, from: data) {
                            guard let code = response.response?.statusCode else { return }
                            feilure?(errorJson, code)
                            return
                        }
                        break
                    default: break
                    }
                    break
                case .failure(let error):
                    feilure?(.init(detail: error.localizedDescription), 404)
                    break
                }
        }
    }
    
    func delete(url: String,
                success: @escaping () -> Void,
                feilure: @escaping (ZSErrorModel) -> Void) {
        
        let fullPath = self.baseURL + url
        guard let url = URL(string: fullPath) else { return }
        
        Alamofire.request(
            url, method: .delete, parameters: nil,
            encoding: JSONEncoding.default, headers: self.headers)
            .responseData { (response) in
                switch (response.result) {
                case .success(_):
                    guard let code = response.response?.statusCode else { return }
                    switch code {
                    case 200...299:
                        success()
                        break
                    case 401:
                        feilure(.init(detail: "Unauthorized"))
                        break
                    default:
                        feilure(.init(detail: "Unknowed error"))
                        break
                    }
                    break
                case .failure(let error):
                    feilure(.init(detail: error.localizedDescription))
                    break
                }
        }
    }
    
    func printJson(from response: DataResponse<Data>) {
        if let json = response.result.value {
            if let str = String(bytes: json, encoding: .utf8) {
                print(response.result)
                print("Json: " + str)
            }
        }
    }
    
    func printBody(from response: DataResponse<Data>) {
        if let request = response.request {
            if let body = request.httpBody {
                if let str = String(bytes: body, encoding: .utf8) {
                    print("Request: \(request)")
                    print("Body: " + str)
                }
            }
            
        }
    }
    
}
