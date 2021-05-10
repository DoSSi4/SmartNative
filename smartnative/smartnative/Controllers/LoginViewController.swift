//
//  LoginViewController.swift
//  smartnative
//
//  Created by DoSSi4 on 30.03.2021.
//

import UIKit

class LoginViewController: UIViewController {
    private let maxPhoneNumber = 11
    private let regex = try! NSRegularExpression(pattern: "[\\+\\s-\\(\\)]", options: .caseInsensitive)
    @IBOutlet private weak var phoneTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var joinBttn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(imageView)
        self.view.sendSubviewToBack(imageView)
        phoneTextField.delegate = self
        
    }
    
    @IBAction func joinRequest(_ sender: UIButton) {
        let urlPath: String = "https://smartbazar.kz/api/auth/login"
        let url: URL = URL(string: urlPath)!
        var request: URLRequest = URLRequest(url: url)
        var request1: URLRequest = URLRequest(url: URL(string: "https://smartbazar.kz/api/auth/me")!)
        request.httpMethod = "POST"
        request1.httpMethod = "POST"
        request.setValue("application/json;charset=UTF-8", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request1.setValue("application/json;charset=UTF-8", forHTTPHeaderField: "Content-Type")
        request1.setValue("application/json", forHTTPHeaderField: "Accept")
        let jsonDictionary: [String: String?] = [
            "phone": phoneTextField.text,
            "password": passwordTextField.text
        ]
        let jsonParam = try? JSONSerialization.data(withJSONObject: jsonDictionary, options: .prettyPrinted)
        let task = URLSession.shared.uploadTask(with: request, from: jsonParam){ data, response, error in
            if let data = data{
            if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]{
                if let token = json["access_token"] as? String{
                    print(token)
                    request1.setValue("Bearer" + token, forHTTPHeaderField: "Authorization")}
                URLSession.shared.dataTask(with: request1){data,response,error in
                    
                    print("Success")
                }.resume()
            }
            }
        }
        task.resume()
    }
        
    @IBAction func resetPass(_ sender: Any) {
        self.performSegue(withIdentifier: "toReset", sender: self)
        
        
    }
    @IBAction func registrationTransfer(_ sender: UIButton) {
       let vc = storyboard?.instantiateViewController(identifier: "RegistrationViewController") as! RegistrationViewController
        vc.modalPresentationStyle = .fullScreen
//        navigationController?.pushViewController(vc, animated: true)
        present(vc, animated: true, completion: nil)
        
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
extension LoginViewController: UITextFieldDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let fullString = (textField.text ?? "") + string
        textField.text = format(phoneNumber: fullString, shouldRemoveLastDigit: range.length == 1)
        return false
    }
    
}
