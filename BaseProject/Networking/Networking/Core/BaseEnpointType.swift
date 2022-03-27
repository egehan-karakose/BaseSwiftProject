//
//  BaseEnpointType.swift
//  Network
//
//  Created by Egehan KARAKÖSE (Dijital Kanallar Uygulama Geliştirme Müdürlüğü) on 27.03.2022.
//

import Foundation
import Common

open class BaseEndpointType: EndpointType {
    
    public var endpoint: Endpoint {
        return mEndpoint
    }
    
    public var mEndpoint: Endpoint!
    
    public init() {}
    
    public func getBodyParametersWithRequest(_ request: Codable?) -> Parameters {
        guard let request = request else { return [:] }
        return request.getParameters()
    }
    
}

