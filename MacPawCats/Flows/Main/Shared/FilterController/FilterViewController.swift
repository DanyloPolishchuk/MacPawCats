//
//  FilterViewController.swift
//  MacPawCats
//
//  Created by Danylo Polishchuk on 11.05.2020.
//  Copyright © 2020 Polishchuk company. All rights reserved.
//

import UIKit

class FilterViewController: UIViewController, StoryboardInitializable {

    //MARK: - Properties
    //
    var viewModel: FilterViewModel!
    var pickerViewTotalHeight: CGFloat!
    let animationDuration = 0.5
    
    //MARK: - Outlets
    //
    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var pickerViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var bgView: UIView!
    
    //MARK: - Lifecycle methods
    //
    override func viewDidLoad() {
        super.viewDidLoad()
        pickerViewTotalHeight = pickerView.frame.height + toolBar.frame.height + 100 // +100 just so pickerView is not initially visible on X's where safeArea differs
        setupPickerViewDefaultUI()
        setupPickerView()
        setupDefaultSelectedRows()
        setupSwipeRecognizer()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        unHideUI()
    }
    
    //MARK: - Setup methods
    //
    private func setupPickerViewDefaultUI(){
        bgView.alpha = 0
        pickerViewBottomConstraint.constant = -pickerViewTotalHeight
    }
    private func setupPickerView(){
        pickerView.dataSource = self
        pickerView.delegate = self
    }
    private func setupDefaultSelectedRows(){
        let defaultSelectedIndexPaths = viewModel.getDefaultSelectedIndexPaths()
        for indexPath in defaultSelectedIndexPaths {
            pickerView.selectRow(indexPath.row, inComponent: indexPath.section, animated: true)
        }
    }
    private func setupSwipeRecognizer(){
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture))
        swipeDown.direction = .down
        self.view.addGestureRecognizer(swipeDown)
    }
    
    //MARK: @objc methods
    //
    @objc private func handleGesture(){
        cancel()
    }
    
    //MARK: - Animation methods
    //
    private func unHideUI(){
        UIView.animate(withDuration: animationDuration) {
            self.bgView.alpha = 0.4
            self.pickerViewBottomConstraint.constant = 0
            self.view.layoutIfNeeded()
        }
    }
    private func hideUI(){
        UIView.animate(withDuration: animationDuration) {
            self.bgView.alpha = 0
            self.pickerViewBottomConstraint.constant = -self.pickerViewTotalHeight
            self.view.layoutIfNeeded()
        }
    }
    
    //MARK: - Completion methods
    //
    private func cancel(){
        hideUI()
        self.dismiss(animated: true)
    }
    private func done(){
        viewModel.saveChanges {
            self.hideUI()
            self.dismiss(animated: true)
        }
    }
    
    //MARK: - Actions
    //
    @IBAction func cancelAction(_ sender: UIBarButtonItem) {
        cancel()
    }
    @IBAction func doneAction(_ sender: UIBarButtonItem) {
        done()
    }
        
}

//MARK: - UIPickerViewDataSource
//
extension FilterViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return viewModel.numberOfComponents()
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return viewModel.numberOfRowsIn(component: component)
    }
}

//MARK: - UIPickerViewDelegate
//
extension FilterViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return viewModel.titleFor(row: row, component: component)
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        viewModel.didSelect(row: row, inComponent: component)
    }
}
