//
//  ResizingView.swift
//  DribbleChallenge
//
//  Created by Ashley Arthur on 03/04/2017.
//  Copyright © 2017 AshArthur. All rights reserved.
//

import Foundation
import UIKit

protocol Resizeable: class {
}
extension Resizeable {
    
    func resize(layer:CALayer){
        for child in layer.sublayers ?? [] {
            child.frame = layer.bounds
            resize(layer: child)
        }
    }
    
}
