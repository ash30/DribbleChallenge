//
//  DialView.swift
//  DribbleChallenge
//
//  Created by Ashley Arthur on 16/03/2017.
//  Copyright © 2017 AshArthur. All rights reserved.
//

import Foundation
import UIKit


// MARK: DIAL CELL

fileprivate class internalViewCell: UICollectionViewCell {
    
    // MARK: PROPERTIES 
    
    private static let heightConstraintMultiplierID = UUID().uuidString
    static let defaultPadding:CGFloat = 0.66
    
    var padding: CGFloat { // Padding is the gap between collection cell and child gradient view

        get{
            return gradient.constraints.first?.multiplier ?? 1.0
        }
        set(mult) {
            _ = contentView.constraints.filter {
                if let s = $0.identifier, s == internalViewCell.heightConstraintMultiplierID {
                    return true
                }
                return false
                }.map {
                    let newConstraint = gradient.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: mult)
                    NSLayoutConstraint.deactivate([$0])
                    NSLayoutConstraint.activate([newConstraint])
            }
        }
    }
    
    // MARK: VIEWS
    
    var gradient: UIGradientView!

    func _createSubviews(){
        
        gradient = { () -> UIGradientView in
            let v = UIGradientView()
            v.translatesAutoresizingMaskIntoConstraints = false
            let constraints = [
                v.widthAnchor.constraint(equalTo: v.heightAnchor),
                v.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
                v.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
                v.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: internalViewCell.defaultPadding)
            ]
            constraints.last!.identifier = internalViewCell.heightConstraintMultiplierID
            contentView.addSubview(v)
            NSLayoutConstraint.activate(constraints)
            return v
        }()
    }
    
    // MARK: INITs
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        _createSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        _createSubviews()
    }
    
    // MARK: LIFE CYCLE
    
    override func prepareForReuse() {
        super.prepareForReuse()
        gradient.removeTarget(nil, action: nil, for: [.allTouchEvents])
    }
    
}


// MARK: DIALER VIEW

class UIDialerView: UIView {
    
    // MARK: CLASS VARS
    
    fileprivate static let internalResuseIdent = UUID().uuidString
    
    // MARK: CONFIGs
    
    var numItems = 12 {
        didSet{
            collectionView.reloadData()
        }
    }
    var rowCount: Int  = 3
    
    var textSize: Int = 12
    var padding: CGFloat = 0.66
    
    var gradientDirection: GradientDirection = .vertical
    var startColor: CGColor = UIColor(colorLiteralRed: 0.1372, green: 0.3254, blue: 0.63921, alpha: 1.0).cgColor
    var endColor: CGColor = UIColor(colorLiteralRed: 0.6470, green: 0.1607, blue: 0.3803, alpha: 1.0).cgColor

    // MARK: DELEGATE
    
    var dataSource: UIDialerViewDataSource? {
        didSet {
            collectionView.reloadData()
        }
    }
    
    // MARK: CHILD COLLECTION VIEW
    
    var collectionView: UICollectionView! {
        didSet{
            collectionView.register(
                internalViewCell.self, forCellWithReuseIdentifier: UIDialerView.internalResuseIdent
            )
        }
    }

    // MARK: INIT
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func setup(){
        
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0.0
        layout.minimumInteritemSpacing = 0.0
        layout.sectionInset = UIEdgeInsets.zero
        layout.scrollDirection = .vertical
        
        collectionView = UICollectionView.init(frame: CGRect.init(x: 0, y: 0, width: 100, height: 100), collectionViewLayout: layout)
        
        collectionView.layoutMargins = UIEdgeInsets.zero
        collectionView.backgroundColor = nil
        
        addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self 
        layoutMargins =  UIEdgeInsets.zero
        
        // LAYOUT
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        let margins = layoutMarginsGuide
        let constraints = [
            collectionView.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: margins.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: margins.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: margins.bottomAnchor),
            ]
        NSLayoutConstraint.activate(constraints)
        
    }
    
}

// MARK: LAYOUT AND SIZING

extension UIDialerView: UICollectionViewDelegateFlowLayout {
    
    override var intrinsicContentSize: CGSize {
        let spacing = textSize * 2
        return CGSize(width: (textSize + spacing) * rowCount, height: (numItems / rowCount) * (textSize + spacing) )
    }
    
    func resize(){
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let parentViewSize = collectionView.frame
        let cellSize = (parentViewSize.width / CGFloat(rowCount)) - 1
        return CGSize(width: cellSize, height: cellSize)
        
    }
}


// MARK: DATA SOURCE 

extension UIDialerView: UICollectionViewDataSource {
    
    
    // MARK: DATA SOURCE
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource?.dialViewItemCount ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: UIDialerView.internalResuseIdent, for: indexPath) as! internalViewCell
        
        // Setup Cell
        setCellLocalGradient(indexPath: indexPath, cell: cell)
        cell.gradient.titleLabel?.textAlignment = .center
        cell.padding = padding
        cell.gradient.tag = indexPath.item
        
        dataSource?.dialView(cell.gradient, index: indexPath.item)
        
        return cell
        
        
    }
}


// MARK: APPEARANCE

fileprivate extension CGColor {
    
    var componentsVec: [CGFloat]? {
        guard let components = components else {
            return nil
        }
        if components.count == numberOfComponents {
            return components
        }
        else if components.count > 0 { // sometimes (e.g black) we only get one number stored
            return Array.init(repeating: components.first!, count: numberOfComponents)
        }
        else {
            return nil
        }
    }
}

fileprivate extension UIDialerView {
    
    func setCellLocalGradient(indexPath:IndexPath, cell: internalViewCell){
        
        let grid = CellLayoutGrid(numItems: numItems, rowCount: rowCount)
        let cellCoord = grid.normalisedCellCoordinates(index: indexPath.item)
        
        guard
            let color1 = startColor.componentsVec,
            let color2 = endColor.componentsVec
            else{
                return
        }
        let colorTransitionVector = zip(color2, color1).map { $0 - $1 }
        let gradientDirectorVector  = gradientDirection.gradientAsVector()
        
        let cellStartColor = { () -> [CGFloat] in
            let mults = ( x: cellCoord.x * CGFloat(gradientDirectorVector.x), y: cellCoord.y * CGFloat(gradientDirectorVector.y))
            let offset = colorTransitionVector.map{ $0 * max(mults.x,mults.y) }
            return zip(color1, offset).map { $0 + $1 }
        }()
        
        let cellEndColor = { () -> [CGFloat] in
            let mults = (
                x: (cellCoord.x + grid.normalisedGridScaleX ) * CGFloat(gradientDirectorVector.x),
                y: (cellCoord.y + grid.normalisedGridScaleY ) * CGFloat(gradientDirectorVector.y)
            )
            let offset = colorTransitionVector.map{ $0 * max(mults.x,mults.y) }
            return zip(color1, offset).map { $0 + $1 }
        }()
        
        cell.gradient.startColor = UIColor(red: cellStartColor[0], green: cellStartColor[1], blue: cellStartColor[2], alpha: 1.0)
        cell.gradient.endColor = UIColor(red: cellEndColor[0], green: cellEndColor[1], blue: cellEndColor[2], alpha: 1.0)
        cell.gradient.direction = gradientDirection
        
    }
}




