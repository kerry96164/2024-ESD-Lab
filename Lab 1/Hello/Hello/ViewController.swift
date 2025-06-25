//
//  ViewController.swift
//  Hello
//
// /Users/kerrylu/Desktop/Hello/Hello/ViewController.swift Created by Kerry Lu on 2024/2/27.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var helloLable: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func sayHelloPressed(_ sender: Any) {
        //將在nameTextField的內容合成新的字串
        let helloString = "Hello \(nameTextField.text!)!"
        //設定helloString到字串
        helloLable.text = helloString
        //clear nameTextField input
        nameTextField.text = ""
    }

}

