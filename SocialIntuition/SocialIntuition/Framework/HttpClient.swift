//
//  HttpClient.swift
//  Social Intuition
//
//  Created by Will Stevens on 12/31/16.
//  Copyright © 2016 Will Stevens. All rights reserved.
//

import Foundation
import Alamofire
import EVReflection
import UIKit

class HttpClient {

//        static let DOMAIN = "http://localhost:8080"
    static let DOMAIN = "https://socialintuition.co"
    
    private static let SERVICE_URI = DOMAIN + "/api"
    var session: Session?
    
    func initialize() {
        
        let configuration = URLSessionConfiguration.default
        let manager = Alamofire.SessionManager(configuration: configuration)
        
        manager.delegate.sessionDidReceiveChallenge = { session, challenge in
            var disposition: URLSession.AuthChallengeDisposition = .performDefaultHandling
            var credential: URLCredential?
            
            if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust {
                disposition = URLSession.AuthChallengeDisposition.useCredential
                credential = URLCredential(trust: challenge.protectionSpace.serverTrust!)
            } else {
                if challenge.previousFailureCount > 0 {
                    disposition = .cancelAuthenticationChallenge
                } else {
                    credential = manager.session.configuration.urlCredentialStorage?.defaultCredential(for: challenge.protectionSpace)
                    
                    if credential != nil {
                        disposition = .useCredential
                    }
                }
            }
            
            return (disposition, credential)
        }
    }
    
    func get<T>(_ endpoint: String, completionHandler: @escaping ((Response<T>)->())) {
        let URL = HttpClient.SERVICE_URI + endpoint
        let headers = getDefaultHeaders()
        loadCookie()
        
        Alamofire.request(URL, headers: headers)
            .responseObject { (response: DataResponse<Response<T>>) in
                if let siResponse = response.result.value {
                    completionHandler(siResponse)
                }
        }
    }
    
    func getArray<T>(_ endpoint: String, completionHandler: @escaping ((ResponseWithArray<T>)->())) {
        let URL = HttpClient.SERVICE_URI + endpoint
        let headers = getDefaultHeaders()
        loadCookie()
        print("URL \(URL)")
        Alamofire.request(URL, headers: headers)
            .responseObject { (response: DataResponse<ResponseWithArray<T>>) in
                if let siResponse = response.result.value {
                    completionHandler(siResponse)
                } else {
                    print("HTTP Error: \(response.result)")
                }
        }
    }
    
    func post<T, P: EVObject>(_ endpoint: String, postBodyObject: P?, completionHandler: @escaping ((Response<T>)->())) {
        let URL = HttpClient.SERVICE_URI + endpoint
        let headers = getDefaultHeaders()
        loadCookie()
        
        // This cast must be done due to the compiler not reconciling the P generic type as an EVObject
        var json = postBodyObject?.toJsonString()
        if json == nil {
            json = ""
        }
//        print("JSON: \(json)")
        
        Alamofire.request(URL, method: .post, parameters: [:], encoding: json!, headers: headers)
            .responseObject { (response: DataResponse<Response<T>>) in
                if let siResponse = response.result.value {
                    // handle reponse hook
                    self.handleResponse(response)
                    completionHandler(siResponse)
                }
        }
    }
    
    func upload<T>(_ endpoint: String, image: UIImage, fileName: String, uploadCompletionHandler: @escaping ((Response<T>)->())) {
        let URL = HttpClient.SERVICE_URI + endpoint
        let headers = getDefaultHeaders()
//        let imageData = UIImageJPEGRepresentation(image, 0.1)
        let imageData = image.jpegData(compressionQuality: 0.1)
        loadCookie()
        
        // solution from here: http://stackoverflow.com/questions/39630997/alamofire-4-0-upload-multipartformdata-header
        //                      https://www.raywenderlich.com/147086/alamofire-tutorial-getting-started-2
        Alamofire.upload(multipartFormData:{ multipartFormData in
            multipartFormData.append(imageData!, withName: "file", fileName: fileName, mimeType: "image/jpeg")},
                         usingThreshold:UInt64.init(),
                         to: URL,
                         method: .post,
                         headers: headers,
                         encodingCompletion: { encodingResult in
                            switch encodingResult {
                            case .success(let upload, _, _):
                                upload.responseObject { (response: DataResponse<Response<T>>) in
                                    if let siResponse = response.result.value {
                                        uploadCompletionHandler(siResponse)
                                    }
                                }
                            case .failure(let encodingError):
                                print(encodingError)
                            }
        })
    }
    
    func postWithUpload<T, P: EVObject>(_ endpoint: String, postBodyObject: P?, jsonName: String, image: UIImage?, fileName: String, postWithUploadCompletionHandler: @escaping ((Response<T>)->())) {
        let URL = HttpClient.SERVICE_URI + endpoint
        let headers = getDefaultHeaders()
        var imageData: Data? = nil
        if let img = image {
            imageData =  img.jpegData(compressionQuality: 0.1)
        }
        loadCookie()
        
        var json = postBodyObject?.toJsonString()
        if json == nil {
            json = ""
        }
        //        print("JSON: \(json)")
        
        Alamofire.upload(multipartFormData:{ multipartFormData in
            multipartFormData.append(json!.data(using: .utf8)!, withName: jsonName)
            if image != nil {
                multipartFormData.append(imageData!, withName: "file", fileName: fileName, mimeType: "image/jpeg")
            }
        },
             usingThreshold: UInt64.init(),
             to: URL,
             method: .post,
             headers: headers,
             encodingCompletion: { encodingResult in
                switch encodingResult {
                case .success(let upload, _, _):
                    upload.responseObject { (response: DataResponse<Response<T>>) in
                        if let siResponse = response.result.value {
                            postWithUploadCompletionHandler(siResponse)
                        }
                    }
                case .failure(let encodingError):
                    print(encodingError)
                }
        })
    }
    
    private func getDefaultHeaders() -> HTTPHeaders {
        
        var headers: HTTPHeaders = [:]
        
        // there is only a userId if a session is set, but none if not logged in
        if (session!.isUserIdInitialized()) {
            headers["userId"] = session?.userId
        }
    
        // there should always be a deviceId
//        headers["deviceId"] = session?.deviceId;
        if (session!.isDeviceIdInitialized()) {
            headers["deviceId"] = session?.deviceId;
        }
        
//        print(headers)
        
        return headers
    }
    
    private func loadCookie() {
        // only set cookie if it is present 
        
        if let httpSessionId = session?.httpSessionId {
            if (Alamofire.SessionManager.default.session.configuration.httpCookieStorage == nil) {
                Alamofire.SessionManager.default.session.configuration.httpCookieStorage = HTTPCookieStorage()
            }
            
            let httpSessionIdString = httpSessionId as String
            let properties = [
                //   HTTPCookiePropertyKey.domain: "httpbin.org",
                HTTPCookiePropertyKey.domain: "localhost",
                HTTPCookiePropertyKey.path: "/",
                HTTPCookiePropertyKey.name: "JSESSIONID",
                HTTPCookiePropertyKey.value: httpSessionIdString
                
            ]
            let cookie = HTTPCookie(properties: properties)
//            print(cookie)
            Alamofire.SessionManager.default.session.configuration.httpCookieStorage?.setCookie(cookie!)
        }
    }
    
    private func handleResponse<T>(_ response: DataResponse<Response<T>>) {
        // first look for httpSessionId and store it if present (only on login)
        if let httpSessionId = response.response?.allHeaderFields["httpSessionId"] as? String {
            session?.httpSessionId = httpSessionId
        }
    }
}


extension String: ParameterEncoding {
    public func encode(_ urlRequest: URLRequestConvertible, with parameters: Parameters?) throws -> URLRequest {
        var request = try urlRequest.asURLRequest()
        request.httpBody = data(using: .utf8, allowLossyConversion: false)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        return request
    }
    
}
