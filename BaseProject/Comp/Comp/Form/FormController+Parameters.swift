//
//  FormController+Parameters.swift
//  Comp
//
//  Created by Egehan KARAKÖSE (Dijital Kanallar Uygulama Geliştirme Müdürlüğü) on 27.03.2022.
//

import Foundation
import Common

extension FormController {
    
    public func getEnabledRows() -> [FormRowDataSource]? {
        let enabledRows = data?
            .filter({ $0.isEnabled })
            .compactMap({ $0.rows })
            .flatMap({ $0 })
            .filter({ $0.isEnabled })
        
        return enabledRows
    }
    
    // FIXME: functional a çevir
    public func getParameters() -> Parameters? {
        
        let validParams = getEnabledRows()?
            .compactMap({ (row) -> Parameters? in
                return row.parameter
            })
        
        var parameters: Parameters = [:]
        validParams?.forEach({ parameter in
            for (key, value) in parameter {
                parameters[key] = value
            }
        })
        
        let dotNotationedParameters = ParametersHelper.getDotNotationedParameters(parameters)
        return dotNotationedParameters
    }
    
}
