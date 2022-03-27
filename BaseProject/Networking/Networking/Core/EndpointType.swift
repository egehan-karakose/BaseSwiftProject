//
//  EndpointType.swift
//  Network
//
//  Created by Egehan KARAKÖSE (Dijital Kanallar Uygulama Geliştirme Müdürlüğü) on 27.03.2022.
//
import Foundation
import Common
import PKHUD
import UIKit
import Comp

public class Endpoint {
    var baseURL: URL
    var path: String
    var parameters: Parameters
    var httpMethod: HTTPMethod
    var httpTask: HTTPTask
    var httpHeaders: HTTPHeaders
    
    public init(baseURL: URL = Environment.shared.current.url,
                path: String,
                parameters: Parameters = [:],
                httpMethod: HTTPMethod,
                httpTask: HTTPTask,
                httpHeaders: HTTPHeaders = .json) {
        self.baseURL = baseURL
        self.path = path
        self.parameters = parameters
        self.httpMethod = httpMethod
        self.httpTask = httpTask
        self.httpHeaders = httpHeaders
    }
}

public protocol Retrieve {
    func retrieve<T: Codable>(_ success: @escaping (T?) -> Void, failure: ((ErrorPair?) -> Void)?)
    func retrieveWithProgress<T: Codable>(_ success: @escaping (T?) -> Void, failure: ((ErrorPair?) -> Void)?)
}

public protocol EndpointType: Retrieve {
    var baseURL: URL { get }
    var path: String { get }
    var parameters: Parameters { get }
    var httpMethod: HTTPMethod { get }
    var httpTask: HTTPTask { get }
    var httpHeaders: HTTPHeaders { get }
    var endpoint: Endpoint { get }
    func requestCompleted()
}

public extension EndpointType {
    
    func requestCompleted() {}
    
    var endpoint: Endpoint {
        return Endpoint(baseURL: baseURL, path: path, parameters: parameters, httpMethod: httpMethod, httpTask: httpTask, httpHeaders: httpHeaders)
    }
    
    var baseURL: URL {
        return Environment.shared.current.url
    }
    
    var path: String {
        return ""
    }
    
    var parameters: Parameters {
        return [:]
    }
    
    var httpMethod: HTTPMethod {
        return .post
    }
    
    var httpTask: HTTPTask {
        return .request
    }
    
    // Default HTTPHeader value is json. If you wanna change,
    // please add "var httpHeaders: HTTPHeaders" to your enum which was implemented EndpointType
    var httpHeaders: HTTPHeaders {
        return .json
    }
    
    func buildRequest() throws -> URLRequest {
        var request = URLRequest(url: endpoint.baseURL.appendingPathComponent(endpoint.path),
                                 cachePolicy: .reloadIgnoringLocalAndRemoteCacheData,
                                 timeoutInterval: 60.0)
        
        request.allHTTPHeaderFields = endpoint.httpHeaders.value
        request.httpMethod = endpoint.httpMethod.rawValue
        
        do {
            switch endpoint.httpTask {
            case .request: break
            case .requestParameters(let parameters,
                                    let encoding):
                
                try configureParameters(parameters: parameters,
                                        encoding: encoding,
                                        request: &request)
            }
            return request
        } catch {
            throw error
        }
    }
    
    private func configureParameters(parameters: Parameters?, encoding: ParameterEncoding, request: inout URLRequest) throws {
        try encoding.encode(urlRequest: &request, parameters: parameters)
    }
    
    // MARK: - Base Request Trigger!!
    
    func retreiveWithoutCallback() {
        let router = Router<Self>()
        router.request(self)
    }
    
    func retrieveWithProgress<T: Codable>(_ success: @escaping (T?) -> Void, failure: ((ErrorPair?) -> Void)? = nil) {
        HUD.show(.progress)
        retrieve({ (response: T?) in
            HUD.hide(animated: false)
            success(response)
        }) { (error) in
            HUD.hide(animated: false)
            if let failure = failure {
                failure(error)
            } else {
                let doneAction = self.getDoneAction(error: error)
                showAlert(withTitle: "Hata".localized, message: error?.message, shouldDismissWhenTappedAround: false, actions: [doneAction])
            }
        }
    }
    
    func retrieve<T: Codable>(_ success: @escaping (T?) -> Void, failure: ((ErrorPair?) -> Void)? = nil) {
        let router = Router<Self>()

        router.request(self) { (response: Result<T, BError>) in
            self.requestCompleted()
            
            switch response {
            case .success(let successModel):
                success(successModel)
            case .failure(let error):
                self.handleFailure(error: error, failure: failure)
            }
        }
    }
    
    private func getDoneAction(error: ErrorPair?) -> AlertAction {
        var doneAction = DesignatedAlertActions.doneAction.action
        // Error Code
        if error?.code == "404" {
            doneAction = DesignatedAlertActions.doneActionWithHandler({
                if var topController = AlertManager.getRootViewController() {
                    if let tapBar = topController as? UITabBarController, let controller = tapBar.selectedViewController {
                        topController = controller
                    }
                    while let presentedViewController = topController.presentedViewController {
                        topController = presentedViewController
                    }
                    if let navigationController = topController as? UINavigationController {
                        navigationController.popViewController(animated: true)
                    }
                }
            }).action
        }
        
        return doneAction
    }
    
    private func handleFailure(error: BError, failure: ((ErrorPair?) -> Void)? = nil) {
        if case BError.authentication = error {
            let doneAction = DesignatedAlertActions.doneActionWithHandler {
                NetworkCommunicationManager.shared.logout?()
            }.action
            showAlert(withTitle: "Hata".localized,
                      message: "Uzun süredir işlem yapmadığınız için oturumunuz sonlandırılmıştır.".localized,
                      actions: [doneAction])
            return
        }
        if let failure = failure {
            failure(ErrorPair.messaged(with: error.localizedDescription))
        } else {
            let doneAction = DesignatedAlertActions.doneAction.action
            showAlert(withTitle: "Hata".localized, message: error.errorDescription, actions: [doneAction])
        }
    }
    
}
