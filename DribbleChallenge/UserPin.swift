//
//  UserPin.swift
//  DribbleChallenge
//
//  Created by Ashley Arthur on 05/04/2017.
//  Copyright © 2017 AshArthur. All rights reserved.
//

import Foundation
import UIKit

class PinValidator {
    
    var attempt: [Int] = [1,2,3,4]
    
}

extension PinValidator: UIDialerViewDataSource {
    var dialViewItemCount: Int {
        return attempt.count
    }
    
    func dialView(_ button: UIButton, index: Int) {
        button.isEnabled = false
    }
}
