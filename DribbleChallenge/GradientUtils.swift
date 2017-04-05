//
//  GradientUtils.swift
//  DribbleChallenge
//
//  Created by Ashley Arthur on 03/04/2017.
//  Copyright © 2017 AshArthur. All rights reserved.
//

import Foundation
import UIKit


enum GradientDirection {
    
    typealias GradientVector = (x:Int, y:Int)
    
    case horizontal
    case vertical
    case diagonal
    case unknown
    
    func gradientAsVector() -> GradientVector {
        switch self {
        case .vertical:
            return (0,1)
        case .horizontal:
            return (1,0)
        default:
            return (0,1) // TODO: define the rest
        }
    }
}


struct CellLayoutGrid {
    
    // Given a range of cells, express index
    // witin a 2D coordinate system
    
    typealias GridPoint = (x:CGFloat, y:CGFloat)
    
    let numItems: Int
    let rowCount: Int
    
    var normalisedGridScaleX: CGFloat {
        return normalisedCellCoordinates(x: 1, y: 0).0
    }
    var normalisedGridScaleY: CGFloat {
        return normalisedCellCoordinates(x: 0, y: 1).1
    }
    
    // MARK: METHODS
    
    func cellCoordinates(index:Int) -> (x:Int, y:Int) {
        return (x: index % rowCount, y: index / rowCount)
    }
    
    func normalisedCellCoordinates(index:Int) -> GridPoint {
        let coords = cellCoordinates(index: index)
        return normalisedCellCoordinates(x: coords.x, y: coords.y)
    }
    
    private func normalisedCellCoordinates(x:Int, y:Int) -> GridPoint {
        // I think this may be wrong... surely to normal width we just use rowCount?
        let scale = CGFloat(numItems / rowCount )
        return (x: CGFloat(x) / CGFloat(numItems), y: CGFloat(y) / CGFloat(rowCount) )
    }


}
