//
//  GradientView.swift
//  DribbleChallenge
//
//  Created by Ashley Arthur on 03/04/2017.
//  Copyright © 2017 AshArthur. All rights reserved.
//

import Foundation
import UIKit

enum GradientDirection {
    
    case horizontal
    case vertical
    case diagonal
    case unknown
    
}

protocol GradientView: class {
    
    var gradientLayer:CAGradientLayer! { get set }
    var startColor: UIColor? { get set }
    var endColor: UIColor? { get set }
    var direction: GradientDirection { get set }
    
}
extension GradientView {
    
    var startColor: UIColor? {
        get {
            guard
                let c = gradientLayer.colors?.first else
            {
                return nil
            }
            let color = c as! CGColor
            return UIColor.init(cgColor: color)
        }
        set(color){
            gradientLayer.colors?[0] = color?.cgColor
        }
    }
    
    var endColor: UIColor? {
        get {
            guard
                let c = gradientLayer.colors?.last else
            {
                return nil
            }
            let color = c as! CGColor
            return UIColor.init(cgColor: color)
        }
        set(color){
            gradientLayer.colors?[1] = color?.cgColor
        }
    }
    
    var direction: GradientDirection {
        get {
            switch gradientLayer.endPoint {
            case CGPoint(x: 0, y: 1):
                return GradientDirection.vertical
            case CGPoint(x: 1, y: 0):
                return GradientDirection.horizontal
            case CGPoint(x: 1, y: 1):
                return GradientDirection.diagonal
            default:
                return GradientDirection.unknown
            }
        }
        set(direction) {
            switch direction {
            case .horizontal:
                gradientLayer.endPoint = CGPoint(x: 1, y: 0)
            case .vertical:
                gradientLayer.endPoint = CGPoint(x: 0, y: 1)
            case .diagonal:
                gradientLayer.endPoint = CGPoint(x: 1, y: 1)
            case .unknown:
                break
            }
        }
    }
    
    func setLayer(_ layer:CALayer){
        gradientLayer = CAGradientLayer()
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        gradientLayer.bounds = layer.bounds
        gradientLayer.colors = [UIColor.red.cgColor, UIColor.red.cgColor]
        layer.addSublayer(gradientLayer)
    }
    
}
