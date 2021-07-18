//
//  SesionManager.swift
//  viper
//
//  Created by  inna on 18/07/2021.
//

import Foundation
import Alamofire

// MARK: - SessionManagerProtocol declaration
public protocol SessionManagerProtocol: AnyObject {
    init(storage: SecureStorageProtocol?, baseUrl: String)
}

// MARK: - SessionManager implementation
public class SessionManager {
    
    // MARK: Private properties
   
    private let baseUrl: String
    
    private var headers: HTTPHeaders? {
        var possibleHeaders: HTTPHeaders?
        
        if let token = secureStorage.obtainToken(),
           let accountId = secureStorage.obtainAccountId(){
            possibleHeaders = HTTPHeaders.default
            possibleHeaders?.add(.defaultUserAgent)
            possibleHeaders?.add(.defaultAcceptLanguage)
        }
        
        return possibleHeaders
    }
    
    // MARK: Lifecycle
   public required init(storage: SecureStorageProtocol? = nil, baseUrl: String) {
        self.baseUrl = baseUrl
    }
    
    // MARK: Private methods
    private func baseURL() -> String {
        
        return baseUrl
    }
   
    private func prefferedParametersEncoding(httpMethod: HTTPMethod) -> ParameterEncoding {
        switch httpMethod {
        case .get:
            return URLEncoding.default
        default:
            return URLEncoding.default
        }
    }
    
    private func processResponse(response: AFDataResponse<Any>, successHandler: (_ data: Data) -> (), failureHandler: (_ error: SError) -> ()) {
        
        if let error = response.error  {
            failureHandler(SError(code: response.response?.statusCode ?? 0, message: error.localizedDescription))
            return
        }
        
        // Response should contain http response?
        guard let httpResponse = response.response else {
            return
        }
        
        // Response should contains JSON
        guard let responseData = response.data else { return }
        
        switch httpResponse.statusCode {
        case 200...299:
            successHandler(responseData)
            break
        default:
            // Error with message
            guard let json = try? response.result.get() as? NSDictionary else { return }
            let message = json["message"] as? String
            let error = SError(code: httpResponse.statusCode, message: message ?? "Undefined error")
            failureHandler(error)
            break
        }
    }
}

extension SessionManager: SessionManagerProtocol {
    
    public func makeRequest(url: String?,
                            method: HTTPMethod,
                            params: [String : Any]?,
                            success: @escaping (_ data: Data) -> (),
                            failure: @escaping (_ error: SError) -> ()) {
        
        
        AF.request(self.targetURL(with: url),
                   method: method,
                   parameters: params,
                   encoding: self.prefferedParametersEncoding(httpMethod: method),
                   headers: self.headers)
            .cURLDescription(calling: { curl in
                print(curl)
            })
            .responseJSON(queue: self.serialQueue) { [weak self] response in
                self?.processResponse(response: response, successHandler: success, failureHandler: failure)
            }
    }
    
}
