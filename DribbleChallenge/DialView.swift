//
//  DialView.swift
//  DribbleChallenge
//
//  Created by Ashley Arthur on 16/03/2017.
//  Copyright © 2017 AshArthur. All rights reserved.
//

import Foundation
import UIKit


protocol CircularView: class {
    var layer:CALayer { get }
}
extension CircularView {
    
    func setLayer(_ layer:CALayer){
        layer.cornerRadius = layer.frame.width / 2.0
        layer.masksToBounds = true
    }
}

protocol GradientView: class {
    var layer:CALayer { get }
}
extension GradientView {
    
    func setLayer(_ layer:CALayer){
        let gradient = CAGradientLayer()
        gradient.frame = layer.frame
        gradient.colors = [UIColor.red.cgColor, UIColor.black.cgColor]
        layer.addSublayer(gradient)
    }
}


class gradientView: UIView, GradientView, CircularView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        createSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        createSubviews()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    func createSubviews(){
        (self as GradientView).setLayer(layer)
        (self as CircularView).setLayer(layer)
        
    }
}

fileprivate class DialCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        _createSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        _createSubviews()
    }
    
    func _createSubviews(){
        contentView.addSubview( gradientView())
    }
}



class UIDialerView: UIView, UICollectionViewDelegateFlowLayout {
    
    private static let internalResuseIdent = UUID().uuidString
    
    var rowCount: Int  = 3
    
    var collectionView: UICollectionView!
    var dataSource: UICollectionViewDataSource? {
        get {
            return collectionView.dataSource
        }
        set(dataSource) {
            collectionView.dataSource = dataSource
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
        layout.scrollDirection = .horizontal
        
        collectionView = UICollectionView.init(frame: CGRect.init(x: 0, y: 0, width: 100, height: 100), collectionViewLayout: layout)
        
        //collectionView.layoutMargins = UIEdgeInsets.zero
        //collectionView.backgroundColor = UIColor.black
        
        addSubview(collectionView)
        collectionView.delegate = self
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
    
    // MARK: FLOW LAYOUT DELEGATE
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let parentViewSize = collectionView.frame
        let cellSize = min(parentViewSize.width, parentViewSize.height) / CGFloat(rowCount)
        return CGSize(width: cellSize, height: cellSize)
        
    }
    
    
}
