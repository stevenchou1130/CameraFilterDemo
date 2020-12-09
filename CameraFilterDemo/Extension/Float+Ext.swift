//
//  Float+Ext.swift
//  CameraFilterDemo
//
//  Created by Steven on 2020/12/9.
//

import Foundation

extension Float {
    
    func floor(toDecimal decimal: Int) -> Float {
        let numberOfDigits = pow(10.0, Double(decimal))
        return Float((Double(self) * numberOfDigits).rounded(.towardZero) / numberOfDigits)
    }
}
