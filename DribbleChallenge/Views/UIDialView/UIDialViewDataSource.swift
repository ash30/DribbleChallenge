//
//  UIDialViewDataSource.swift
//  DribbleChallenge
//
//  Created by Ashley Arthur on 03/04/2017.
//  Copyright © 2017 AshArthur. All rights reserved.
//

import Foundation
import UIKit

// DELEGATE PROTOCOL

protocol UIDialerViewDataSource{
    
    var dialViewItemCount: Int { get }
    
    func dialView(_ button: UIButton, index: Int)
    
}
