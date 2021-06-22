//
//  VerificationViewController.swift
//  smartnative
//
//  Created by DoSSi4 on 23.04.2021.
//

import UIKit

class VerificationViewController: UIViewController {
    let defaults = UserDefaults.standard
    @IBOutlet weak var number1: UITextField!
    @IBOutlet weak var number4: UITextField!
    @IBOutlet weak var number3: UITextField!
    @IBOutlet weak var number2: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        number1.becomeFirstResponder()
        number1.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: .editingChanged)
        number2.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: .editingChanged)
        number3.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: .editingChanged)
        number4.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: .editingChanged)
    }
        // Do any additional setup after loading the view.
    

    @IBAction func confirmCode(_ sender: Any) {
        let confirmtoken = defaults.string(forKey: "token")
        let confirmcode = "\(number1.text!)\(number2.text!)\(number3.text!)\(number4.text!)"
        var request: URLRequest = URLRequest(url: URL(string: "http://smartbazar.kz/api/auth/verify/code")!)
        request.httpMethod = "POST"
        request.setValue("application/json;charset=UTF-8", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
            request.setValue(confirmcode + "Bearer" + confirmtoken!, forHTTPHeaderField: "Authorization")
        URLSession.shared.dataTask(with: request){data, response, error in
            let httpResp = response as? HTTPURLResponse
            if httpResp?.statusCode == 200{
                print("Verified!")
                self.view.window!.rootViewController?.dismiss(animated: true)
            }
            else{
                print("Error!")
            }
        }.resume()
    
}
    @objc func textFieldDidChange(textField: UITextField){

            let text = textField.text

            if text?.utf16.count==1{
                switch textField{
                case number1:
                    number2.becomeFirstResponder()
                case number2:
                    number3.becomeFirstResponder()
                case number3:
                    number4.becomeFirstResponder()
                case number4:
                    number4.resignFirstResponder()
                default:
                    break
                }
            }else{

            }
    }
}

