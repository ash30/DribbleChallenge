//
//  DialView.swift
//  DribbleChallenge
//
//  Created by Ashley Arthur on 16/03/2017.
//  Copyright © 2017 AshArthur. All rights reserved.
//

import Foundation
import UIKit

// MARK: APPEARANCE TRAITS

protocol CircularView: class {
}
extension CircularView {
    
    func setLayer(_ layer:CALayer){
        layer.cornerRadius = layer.frame.width / 2.0
        layer.masksToBounds = true
        layer.backgroundColor = UIColor.red.cgColor
    }
    
}


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
    override func layoutSubviews() {
        super.layoutSubviews()
        resize(layer: layer)
        (self as CircularView).setLayer(layer)
    }
    
    func createSubviews(){
        layoutMargins = UIEdgeInsets.zero
        (self as GradientView).setLayer(layer)
        (self as CircularView).setLayer(layer)
    }
}

// MARK: DIALER VIEW

class UIDialerView: UIView, UICollectionViewDelegateFlowLayout {
    
    // MARK: CLASS VARS
    
    fileprivate static let internalResuseIdent = UUID().uuidString
    
    fileprivate class internalViewCell: UICollectionViewCell {
        
        var gradient: UIGradientView!
        
        var padding: CGFloat {
            get{
                return gradient.constraints.first?.multiplier ?? 1.0
            }
            set(mult) {
                _ = contentView.constraints.filter {
                    if let s = $0.identifier, s == "pad_constraint" {
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

        override init(frame: CGRect) {
            super.init(frame: frame)
            _createSubviews()
        }
        
        required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
            _createSubviews()
        }
        
        // This will be called right after init and so there will be no
        // time for parent collection to edit the value....
        
        func _createSubviews(){
            
            gradient = { () -> UIGradientView in
                let v = UIGradientView()
                v.translatesAutoresizingMaskIntoConstraints = false
                let constraints = [
                    v.widthAnchor.constraint(equalTo: v.heightAnchor),
                    v.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
                    v.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
                    v.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.66)
                    ]
                constraints.last!.identifier = "pad_constraint"
                contentView.addSubview(v)
                NSLayoutConstraint.activate(constraints)
                return v
            }()

            
        }
    }
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
    
    override var intrinsicContentSize: CGSize {
        let spacing = textSize * 2 
        return CGSize(width: (textSize + spacing) * rowCount, height: (numItems / rowCount) * (textSize + spacing) )
    }
    
    // MARK: FLOW LAYOUT DELEGATE
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let parentViewSize = collectionView.frame
        let cellSize = (min(parentViewSize.width, parentViewSize.height) / CGFloat(rowCount)) - 1
        return CGSize(width: cellSize, height: cellSize)
        
    }
    
}

extension UIDialerView: UICollectionViewDataSource {
    
    func cellCoordinates(index:Int) -> (Int,Int) {
        return (x: index % rowCount, y: index / rowCount)
    }
    
    func normalisedCellCoordinates(x:Int, y:Int) -> (CGFloat,CGFloat){
        let scale = CGFloat(numItems / rowCount )
        return (x: CGFloat(x) / scale, y: CGFloat(y) / scale)
    }
    
    func cellGradientCoordinates(index: Int, direction: GradientDirection) -> (CGFloat, CGFloat){
        
        let start_coords = cellCoordinates(index: index)
        let end_coords = (start_coords.0 + 1 , start_coords.1 + 1)
        let norm_start_coords = normalisedCellCoordinates(x: start_coords.0, y: start_coords.1)
        let norm_end_coords = normalisedCellCoordinates(x: end_coords.0, y: end_coords.1)

        switch direction {
        case .vertical:
            return (norm_start_coords.1,norm_end_coords.1)
            
        case .horizontal:
            return (norm_start_coords.0,norm_end_coords.0)

        default:
            // WIP
            return (norm_start_coords.1,norm_end_coords.1)
        }
        
    }
    
    fileprivate func setCellLocalGradient(indexPath:IndexPath, cell: internalViewCell){
        guard let start = startColor.components, let end = endColor.components else {
            return
        }
        
        let startVec = (start.count == 4 ? start : Array.init(repeating: start.first, count: 3)).flatMap{$0}
        let endVec = (end.count == 4 ? end : Array.init(repeating: end.first, count: 3)).flatMap{$0}
        
        guard startVec.count > 2, endVec.count > 2 else {
            return // badly defined colors
        }
        
        let mults = cellGradientCoordinates(index: indexPath.item, direction: gradientDirection)
        let vec = zip(endVec, startVec).map { $0 - $1 }
        
        let localStartColor = zip(startVec, vec.map{$0 * mults.0}).map { $0 + $1 }
        let localEndColor = zip(startVec, vec.map{$0 * mults.1}).map { $0 + $1 }
        
        cell.gradient.startColor = UIColor(red: localStartColor[0], green: localStartColor[1], blue: localStartColor[2], alpha: 1.0)
        cell.gradient.endColor = UIColor(red: localEndColor[0], green: localEndColor[1], blue: localEndColor[2], alpha: 1.0)
        cell.gradient.direction = gradientDirection
        
    }
    
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

        dataSource?.dialView(cell.gradient, index: indexPath.item)
        
        return cell
        
        
    }
}

// DELEGATE PROTOCOL

protocol UIDialerViewDataSource{
    
    var dialViewItemCount: Int { get }
    func dialView(_ button: UIButton, index: Int)
    
}



