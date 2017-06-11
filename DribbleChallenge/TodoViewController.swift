//
//  todoViewController.swift
//  DribbleChallenge
//
//  Created by Ashley Arthur on 09/05/2017.
//  Copyright © 2017 AshArthur. All rights reserved.
//

import Foundation
import UIKit

class TodoViewController: UIViewController{

    
    // MARK: PROPERTIES
    
    var defaultRowHeight = 50.0
    
    lazy var data: OrderedDataSource = {
        let data = TodoDataSource(items: Array(0...10).map{"Todo \($0)"})
        data.observer = self
        return data
    }()
    
    lazy var animator: TodoViewControllerAnimator = {
        let controller = TodoViewControllerAnimator()
        controller.viewController = self
        return controller
    }()
    
    var tableView: UITableView!
    
    var header: TodoTableSectionView!
    
    private var containingView:UIStackView!
    
    lazy var headerTransitionView:UIView? = {
        guard
            let header = self.header,
            let containingView = self.containingView,
            let view = header.contentView.positionedSnapshot(snapshotSuperView: header, afterScreenUpdates: true)
        else {
            return nil
        }
        return view
    }()
    
    
    // MARK: LIFE CYCLE
    
    override func viewDidLoad() {
        
        containingView = {
            // Create parent view for styling
            let view = UIView()
            
            view.translatesAutoresizingMaskIntoConstraints = false
            let constraints = [
                view.topAnchor.constraint(equalTo: self.view.layoutMarginsGuide.topAnchor, constant:35),
                view.bottomAnchor.constraint(equalTo: self.view.layoutMarginsGuide.bottomAnchor),
                view.leadingAnchor.constraint(equalTo: self.view.layoutMarginsGuide.leadingAnchor),
                view.trailingAnchor.constraint(equalTo: self.view.layoutMarginsGuide.trailingAnchor)
            ]
            self.view.addSubview(view)
            NSLayoutConstraint.activate(constraints)
            
            let stack = UIStackView()
            view.addSubview(stack)
            stack.distribution = .fill
            stack.alignment = .fill
            stack.axis = .vertical
            
            stack.translatesAutoresizingMaskIntoConstraints = false
            let stackConstraints = [
                stack.topAnchor.constraint(equalTo: view.topAnchor),
                stack.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                stack.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                stack.trailingAnchor.constraint(equalTo: view.trailingAnchor)
            ]
            view.addSubview(stack)
            NSLayoutConstraint.activate(stackConstraints)
            
            return stack
        }()
        
        header = { 
            let view = TodoTableSectionView()
            view.backgroundColor = UIColor.blue
            view.textfield.delegate = self
            containingView!.addArrangedSubview(view)
            return view
        }()
        
        tableView = {
            let view = UITableView()
            containingView!.addArrangedSubview(view)
            view.dataSource = self
            view.delegate = self
            return view
        }()

        // Display Preferences
        view.backgroundColor = UIColor.red
        tableView.backgroundColor = UIColor.blue
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // We create this here because snapshot needs views displayed
        // but we need it finished before any user interaction\
        headerTransitionView?.isHidden = true
        headerTransitionView?.center.y += 50
        
    }
    
    // FIXME: Rename this, its basically a pre step for header, hiding additional UI before transition
    func animateFoo(indexPath: IndexPath){
        CATransaction.begin()
        CATransaction.setCompletionBlock {
            //self.animatedCreateRow(indexPath: indexPath)
        }
        header.currentDisplayState = .submitted
        CATransaction.commit()
    }
    
}

extension TodoViewController: UITextFieldDelegate {
    
    // MARK: TEXT DELEGATE
    func textFieldDidBeginEditing(_ textField: UITextField){
        animator.animatedHeaderFocus()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let text = textField.text else {
            return
        }
        data.insert(at: 0, item: text)
        textField.text = ""
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }
}

extension TodoViewController: UITableViewDataSource, UITableViewDelegate {
    
    // MARK: DATA SOURCE
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell()
        let todoItem = data.getItem(at: indexPath.item)
        cell.textLabel?.text = "\(todoItem ?? "NIL")"
        cell.selectionStyle = .none
        cell.contentView.backgroundColor = UIColor.white
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    // MARK: TABLEVIEW DELEGATE
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        _ = data.pop(at: indexPath.item)
    }
}

extension TodoViewController: DataSourceObserver {
    
    func didUpdate(dataSource: OrderedDataSource, change:DataSourceChanges) {
        
        switch change {
        case .insert(let n):
            assert(n == 0) // Todo list should also insert at index 0
            animator.animatedCreateRow(indexPath: IndexPath(item: 0, section: 0))
        case .removed(let n):
            animator.animatedRemoveRow(indexPath: IndexPath(item: n, section: 0))
        }
        
    }
    
}

extension UIView {
    
    func positionedSnapshot(snapshotSuperView:UIView, afterScreenUpdates:Bool = false) -> UIView? {
        guard let parent = superview else {
            return nil
        }
        guard let coverImage = resizableSnapshotView(from: bounds, afterScreenUpdates: afterScreenUpdates, withCapInsets: .zero) else {
            print("Snapshot Failed")
            return nil
        }
        coverImage.translatesAutoresizingMaskIntoConstraints = false
        snapshotSuperView.addSubview(coverImage)
        coverImage.frame = parent.convert(frame, to: snapshotSuperView)
        return coverImage
        
    }
    
}

