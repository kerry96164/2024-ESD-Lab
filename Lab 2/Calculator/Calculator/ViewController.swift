//
//  ViewController.swift
//  Calculator
//
//  Created by Kerry Lu on 2024/3/5.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var digitLable: UILabel!
    @IBOutlet weak var operatorLable: UILabel!
    //pressed op then next digit will start a new number
    var shouldStartNewNumberInput = false
    //the pre number
    var pendingNumber = ""
    //按＝兩次，連續計算
    var lastPressedEqualBotton = false
    var previousNumber = ""
    var preverousOperator = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //initial the state of digital and operator
        digitLable.text = "0"
        operatorLable.text = " "
    }

    @IBAction func digitButtonPressed(_ sender: UIButton) {
        lastPressedEqualBotton = false
        //a new number?
        if shouldStartNewNumberInput{
            //save pre number
            pendingNumber = digitLable.text!
            //initial digiLable
            digitLable.text = "0"
            shouldStartNewNumberInput = false
        }
        //如果按下按鈕時，digitLable 為初始０狀態，把０刪掉後再輸入
        //如果是小數點．則不用
        if digitLable.text == "0" && sender.titleLabel?.text != "."{
            digitLable.text = ""
        }
        //將 sender button 的文字接在 digitLabel的文字後方
        //如果按下．但已經有．了，則跳出
        if sender.titleLabel?.text == "." &&
            digitLable.text?.range(of: ".") != nil{
            return
        }
        digitLable.text = digitLable.text! + sender.titleLabel!.text!
    }
    @IBAction func operatorButtonPressed(_ sender: UIButton) {
        lastPressedEqualBotton = false
        //將 sender button 的文字取代 operatorLabel 原有的文字
        caculate()
        self.operatorLable.text = sender.titleLabel?.text
        shouldStartNewNumberInput = true
    }
    @IBAction func equalButtonPressed(_ sender: Any) {
        if lastPressedEqualBotton{
            operatorLable.text = preverousOperator
            pendingNumber = digitLable.text!
            digitLable.text = previousNumber
        }
        else {
            previousNumber = digitLable.text!
            preverousOperator = operatorLable.text!
        }

        caculate()
        lastPressedEqualBotton = true
    }
    @IBAction func allClearButtonPressed(_ sender: Any) {
        digitLable.text = "0"
        operatorLable.text = ""
        shouldStartNewNumberInput = false
        pendingNumber = ""
        previousNumber = ""
        preverousOperator = ""
        lastPressedEqualBotton = false
    }
    @IBAction func backButtonPressed(_ sender: Any) {
        lastPressedEqualBotton = false
        digitLable.text = "\(digitLable.text!.dropLast())"
        if digitLable.text == ""
            || digitLable.text == "-" || digitLable.text == "." {
            digitLable.text = "0"
        }
    }
    
    func caculate(){
        //check operatorLable is nil or empty?
        guard let operatorString = operatorLable.text,
              !operatorString.isEmpty
        else {return}
        
        //check pendingNumber and digitLable can convert to number
        guard let value1 = Double(pendingNumber),
              let value2 = Double(digitLable.text!) else {return}
        
        var result:Double = 0
        print(value1)
        print(value2)
        switch operatorString{
        case "+":
            result = value1 + value2
        case "−":
            result = value1 - value2
        case "×":
            result = value1 * value2
        case "÷":
            result = value1 / value2
        default:
            break;
        }
        
        //show result
        digitLable.text = "\(result)"
        pendingNumber = ""
        operatorLable.text = ""
        shouldStartNewNumberInput = true
        
    }
}

