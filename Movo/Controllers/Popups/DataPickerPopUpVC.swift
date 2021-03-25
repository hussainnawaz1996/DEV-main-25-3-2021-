//
//  DataPickerPopUpVC.swift
//  Movo
//
//  Created by Ahmad on 12/11/2020.
//

import UIKit

typealias DataPickerCompletionHandler = ((Int,String)->())
protocol DataPickerViewDelegate: class {
    func dataPickerDoneButtonPressedWith(index:Int,title:String)
}


class DataPickerPopUpVC: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource {
    
    @IBOutlet weak var bgView: UIView!
    
    @IBOutlet weak var dataPicker: UIPickerView!
    @IBOutlet weak var titleLabel: UILabel!

    var dataPickedHandler:DataPickerCompletionHandler?

    var contentArray = Array<String>()
    var headingTitle: String = ""
    var selectedValue : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView(content: contentArray, title: headingTitle, selectedValue: selectedValue)
    }
    
    func configureView(content:Array<String>,title:String,selectedValue:String) -> Void {
        contentArray = content
        titleLabel.text = title
        dataPicker.reloadComponent(0)
        
        dataPicker.setValue(Colors.BLACK, forKeyPath: "textColor")
        
        if let index = content.lastIndex(of: selectedValue){
            dataPicker.selectRow(index, inComponent: 0, animated: true)
        }
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        UIView.animate(withDuration: 0.5, delay: 0.0, options: UIView.AnimationOptions.curveEaseIn, animations: {
            self.bgView.backgroundColor = Colors.BLACK.withAlphaComponent(0.7)
            
        }, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
        UIView.animate(withDuration: 0.5, delay: 0.0, options: UIView.AnimationOptions.curveEaseIn, animations: {
            self.bgView.backgroundColor = Colors.BLACK.withAlphaComponent(0.7)
            
        }, completion: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        UIView.animate(withDuration: 0.1, delay: 0.0, options: UIView.AnimationOptions.transitionCrossDissolve, animations: {
            self.bgView.backgroundColor = Colors.BLACK.withAlphaComponent(0.0)
        }, completion: nil)
    }
    
    @IBAction func viewWasTapped(_ sender: UITapGestureRecognizer) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func doneButtonWasPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
        let index = dataPicker.selectedRow(inComponent: 0)
        dataPickedHandler?(index, contentArray[index])
    }
    
    
    // MARK:- UIPickerViewDelegate,UIPickerViewDataSource
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return contentArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return contentArray[row]
    }
}
