//
//  UIGradientView.swift
//  DribbleChallenge
//
//  Created by Ashley Arthur on 03/04/2017.
//  Copyright © 2017 AshArthur. All rights reserved.
//

import Foundation
import UIKit

// MARK: GRADIENT VIEW

class UIGradientView: UIButton, CircularView, GradientView, Resizeable {
    
    var gradientLayer:CAGradientLayer!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        createSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        createSubviews()
    }    
    
    override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
        resize(layer: layer)
        (self as CircularView).setLayer(layer)
    }
    
    func createSubviews(){
        layoutMargins = UIEdgeInsets.zero
        (self as GradientView).setLayer(layer)
        (self as CircularView).setLayer(layer)
    }
}
