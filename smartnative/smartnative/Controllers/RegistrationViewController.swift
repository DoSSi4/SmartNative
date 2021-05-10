//
//  RegistrationViewController.swift
//  smartnative
//
//  Created by DoSSi4 on 19.04.2021.
//

import UIKit

class RegistrationViewController: UIViewController {
    private let maxPhoneNumber = 11
    private let regex = try! NSRegularExpression(pattern: "[\\+\\s-\\(\\)]", options: .caseInsensitive)
    @IBOutlet weak var imageTop: UIImageView!
    @IBOutlet private weak var nameTextField: UITextField!
    @IBOutlet private weak var snameTextField: UITextField!
    @IBOutlet private weak var phoneTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var passConfirmTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(imageTop)
        self.view.sendSubviewToBack(imageTop)
        phoneTextField.delegate = self
    }
    @IBAction func registrRequest(_ sender: Any){
        let urlPath: String = "https://smartbazar.kz/api/auth/register"
        let url: URL = URL(string: urlPath)!
        var request: URLRequest = URLRequest(url: url)
        var request1: URLRequest = URLRequest(url: URL(string: "https://smartbazar.kz/api/auth/login")!)
        request1.httpMethod = "POST"
        request.httpMethod = "POST"
        request.setValue("application/json;charset=UTF-8", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request1.setValue("application/json;charset=UTF-8", forHTTPHeaderField: "Content-Type")
        request1.setValue("application/json", forHTTPHeaderField: "Accept")
        let jsonDict: [String: String?] = [
            "phone": phoneTextField.text,
            "password": passwordTextField.text,
            "firstname": nameTextField.text,
            "lastname": snameTextField.text
        ]
        let jsonLogDict: [String: String?] = [
            "phone": phoneTextField.text,
            "password": passwordTextField.text
        ]
        let jsonParam = try? JSONSerialization.data(withJSONObject: jsonDict, options: .prettyPrinted)
        let jsonParam1 = try? JSONSerialization.data(withJSONObject: jsonLogDict, options: .prettyPrinted)
        var token: String = ""
        let task = URLSession.shared.uploadTask(with: request, from: jsonParam){ data, response, error in
            let httpResp = response as? HTTPURLResponse
            if httpResp?.statusCode == 200{
                URLSession.shared.uploadTask(with: request1, from: jsonParam1){data, response, error in
                    if let data = data{
                    if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]{
                        if let tokenunwrap = json["access_token"] as? String{
                            print("Success")
                        token = tokenunwrap
                        }
                    }
                }
                }
            }else{print("Error in login!")}
        }
        task.resume()
        let confirm = VerificationViewController()
        confirm.confirmtoken = token
        self.performSegue(withIdentifier: "Confirm", sender: self)
        
    }
    
    private func format(phoneNumber: String, shouldRemoveLastDigit: Bool) -> String{
        guard !(shouldRemoveLastDigit && phoneNumber.count<=2) else {return "+"}
        let range = NSString(string: phoneNumber).range(of: phoneNumber)
        var number = regex.stringByReplacingMatches(in: phoneNumber, options: [], range: range, withTemplate: "")
        
        if number.count>maxPhoneNumber{
            let maxIndex = number.index(number.startIndex, offsetBy: maxPhoneNumber)
            number = String(number[number.startIndex..<maxIndex])
        }
        if shouldRemoveLastDigit{
            let maxIndex = number.index(number.startIndex, offsetBy: number.count-1)
            number = String(number[number.startIndex..<maxIndex])
        }
        let maxIndex = number.index(number.startIndex, offsetBy: number.count)
        let regRange = number.startIndex..<maxIndex
        
        if number.count < 7 {
            let pattern = "(\\d)(\\d{3})(\\d+)"
            number = number.replacingOccurrences(of: pattern, with: "$1 ($2) $3", options: .regularExpression, range: regRange)
        }
        else {
            let pattern = "(\\d)(\\d{3})(\\d{3})(\\d{2})(\\d+)"
            number = number.replacingOccurrences(of: pattern, with: "$1 ($2) $3 $4$5", options: .regularExpression, range: regRange)

        }
        return "+" + number
    }
    

}
extension RegistrationViewController: UITextFieldDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let fullString = (textField.text ?? "") + string
        textField.text = format(phoneNumber: fullString, shouldRemoveLastDigit: range.length == 1)
        return false
    }
    
}
