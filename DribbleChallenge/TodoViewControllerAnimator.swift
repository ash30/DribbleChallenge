//
//  TodoViewControllerAnimator.swift
//  DribbleChallenge
//
//  Created by Ashley Arthur on 11/06/2017.
//  Copyright © 2017 AshArthur. All rights reserved.
//

import Foundation
import UIKit

fileprivate typealias CustomTransitionView = UIView

fileprivate enum RowRemoveAnimation {
    
    case inactive
    case start(CustomTransitionView)
    case end(IndexPath, UITableViewCell, CustomTransitionView)
    
}

fileprivate enum HeaderFocusAnimation {
    
    case inactive
    case active
    case ending
    
}

fileprivate enum RowCreationAnimation {
    
    case inactive
    case start(IndexPath, CustomTransitionView)
    case ending(IndexPath)
    
}

class TodoViewControllerAnimator {
    
    // MARK: PROPERTIES
    
    weak var viewController: TodoViewController?
    
    private var rowRemovalDisplayState : RowRemoveAnimation = .inactive {
        didSet {
            guard let viewController = viewController else {
                return
            }
            switch rowRemovalDisplayState {
                
            case .start(let coverImage):
                coverImage.transform = coverImage.transform.scaledBy(x: 1.05, y: 1)
                coverImage.layer.zPosition = 1.0
                coverImage.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
                coverImage.layer.shadowRadius = 5.0
                coverImage.layer.shadowOpacity = 0.25
                coverImage.layer.shadowColor = UIColor.black.cgColor
                
            case .end( let index, let cell, let coverImage):
                cell.isHidden = true
                viewController.tableView.deleteRows(at:[index], with:.bottom)
                coverImage.transform = coverImage.transform.translatedBy(x: 0, y: viewController.tableView.bounds.height)
                
            default:
                break
            }
        }
    }
    
    private var rowCreationDisplayState : RowCreationAnimation = .inactive {
        didSet {
            guard let viewController = viewController else {
                return
            }
            switch rowCreationDisplayState {
                
            case .inactive:
                viewController.header.currentDisplayState = .inactive
                viewController.header.contentView.isHidden = false
                viewController.headerTransitionView?.isHidden = true
                
            case .start(let indexPath, let coverImage):
                viewController.tableView?.beginUpdates()
                viewController.tableView.insertRows(at: [indexPath], with: .top)
                viewController.tableView?.endUpdates()
                
                // Snapshot will look like table cell translated down
                let newlyInserted = viewController.tableView.cellForRow(at: indexPath)
                newlyInserted?.isHidden = true
                // FIXME: get rid of magic number
                coverImage.transform = coverImage.transform.translatedBy(x: 0, y: 40.0)
                coverImage.transform = coverImage.transform.scaledBy(x: 0.97, y: 1)
                
            case .ending(let indexPath):
                let newlyInserted = viewController.tableView.cellForRow(at: indexPath)
                newlyInserted?.isHidden = false
                viewController.headerTransitionView?.isHidden = false
                
            }
        }
    }
    
    private var headerFocusDisplayState : HeaderFocusAnimation = .inactive {
        didSet {
            guard let viewController = viewController else {
                return
            }
            
            switch headerFocusDisplayState {
                
            case .inactive:
                viewController.header?.contentView.isHidden = false
                viewController.header.currentDisplayState = .inactive
                
            case .active:
                viewController.header.contentViewHeightMinimumConstraint?.constant = CGFloat(viewController.defaultRowHeight * 1.5)
                viewController.header.contentViewWidthConstraint?.constant = 10.0
                viewController.header.currentDisplayState = .start
                
            case .ending:
                viewController.header.contentViewHeightMinimumConstraint?.constant = CGFloat(viewController.defaultRowHeight)
                viewController.header.contentViewWidthConstraint?.constant = 0
                viewController.header?.contentView.isHidden = true
                
            }
        }
    }
    
    // MARK: METHODS
    
    func animatedCreateRow(indexPath: IndexPath){
        
        guard let viewController = viewController else {
            return
        }
        guard let coverImage = viewController.header?.contentView.positionedSnapshot(snapshotSuperView:viewController.view) else {
            return
        }
        headerFocusDisplayState = .ending
        
        CATransaction.begin()
        
        CATransaction.setCompletionBlock {
            self.rowCreationDisplayState = .ending(indexPath)
            coverImage.removeFromSuperview()
            
            // MARK: SECONDARY HEADER SLIDE UP TRANSITION
            CATransaction.begin()
            CATransaction.setCompletionBlock {
                self.rowCreationDisplayState = .inactive
            }
            // We use explicit layer animation as change is transient
            let animation = CABasicAnimation(keyPath: #keyPath(CALayer.position))
            animation.byValue = CGPoint(x: 0, y: -50)
            animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
            viewController.headerTransitionView?.layer.add(animation, forKey: nil)
            CATransaction.commit()
        }
        
        // 1st
        UIView.animate(withDuration: 0.5, animations: {
            self.rowCreationDisplayState = .start(indexPath, coverImage)
            viewController.view.layoutIfNeeded()
        })
        
        CATransaction.commit()
        
    }
    
    func animatedRemoveRow(indexPath: IndexPath){
        
        guard
            let viewController = viewController,
            let cell = viewController.tableView.cellForRow(at: indexPath),
            let coverImage = cell.contentView.positionedSnapshot(snapshotSuperView: viewController.view)
            else {
                return
        }
        coverImage.layer.cornerRadius = 5.0
        
        CATransaction.begin()
        CATransaction.setCompletionBlock {
            UIView.animate(withDuration: 1.0, animations: {
                // 2nd
                self.rowRemovalDisplayState = .end(indexPath, cell, coverImage)
            }){ _ in
                // 3rd
                coverImage.removeFromSuperview()
                self.rowRemovalDisplayState = .inactive
            }
        }
        UIView.animate(withDuration: 0.3, animations: {
            // 1st
            self.rowRemovalDisplayState = .start(coverImage)
        })
        CATransaction.commit()
    }
    
    func animatedHeaderFocus(){
        guard let vc = viewController else {
            return
        }
        CATransaction.begin()
        headerFocusDisplayState = .active
        UIView.animate(withDuration: 0.3, animations: {
            vc.tableView?.beginUpdates()
            vc.tableView?.endUpdates()
            vc.view.layoutIfNeeded()
        })
        CATransaction.commit()
    }
    
}
