//
//  CircularLayer.swift
//  DribbleChallenge
//
//  Created by Ashley Arthur on 03/04/2017.
//  Copyright © 2017 AshArthur. All rights reserved.
//

import Foundation
import UIKit

protocol CircularView: class {
}
extension CircularView {
    
    func setLayer(_ layer:CALayer){
        layer.cornerRadius = layer.frame.width / 2.0
        layer.masksToBounds = true
        layer.backgroundColor = UIColor.red.cgColor
    }
    
}
