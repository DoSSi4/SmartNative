//
//  ResetPassViewController.swift
//  smartnative
//
//  Created by DoSSi4 on 26.04.2021.
//

import UIKit

class ResetPassViewController: UIViewController {
    private let maxPhoneNumber = 11
    private let regex = try! NSRegularExpression(pattern: "[\\+\\s-\\(\\)]", options: .caseInsensitive)
    @IBOutlet private weak var phoneTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        phoneTextField.delegate = self

        // Do any additional setup after loading the view.
    }
    @IBAction func resetPass(){
        var request1: URLRequest = URLRequest(url: URL(string: "https://smartbazar.kz/api/auth/verify/reset")!)
        request1.httpMethod = "POST"
        request1.setValue("application/json;charset=UTF-8", forHTTPHeaderField: "Content-Type")
        request1.setValue("application/json", forHTTPHeaderField: "Accept")
        let jsonDictionary: [String: String?] = [
            "phone": phoneTextField.text
        ]
        let jsonParam = try? JSONSerialization.data(withJSONObject: jsonDictionary, options: .prettyPrinted)
        let task = URLSession.shared.uploadTask(with: request1, from: jsonParam){ data, response, error in
            if let httpResp = response as? HTTPURLResponse{
                if httpResp.statusCode == 200{
                    let alert = UIAlertController(title: "Успешно!", message: "Ваш новый пароль был отправлен вам на телефон", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ок", style: .default, handler: nil))
                    self.present(alert, animated: true)
                    self.dismiss(animated: true, completion: nil)
                }
                    
                
            }
        }
        task.resume()
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


extension ResetPassViewController: UITextFieldDelegate{
func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    let fullString = (textField.text ?? "") + string
    textField.text = format(phoneNumber: fullString, shouldRemoveLastDigit: range.length == 1)
    return false
}

}
