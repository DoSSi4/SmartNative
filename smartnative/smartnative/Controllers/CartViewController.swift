//
//  CartViewController.swift
//  smartnative
//
//  Created by DoSSi4 on 10.06.2021.
//

import UIKit

class CartViewController: UIViewController {
    @IBOutlet weak var totalCartLabel: UILabel!
    @IBOutlet weak var totalCountLabel: UILabel!
    var CartArr: [Order.Item3] = [Order.Item3](){
        didSet{
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: CartCell.identifier, bundle: nil), forCellReuseIdentifier: CartCell.identifier)
        fetchAPI()
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let defaults = UserDefaults.standard
        if defaults.bool(forKey: "isLoggedIn") == false{
            self.performSegue(withIdentifier: "CartToLogin", sender: self)
        }
    }
    private func fetchAPI(){
        let token = UserDefaults.standard.string(forKey: "token")
        var request: URLRequest = URLRequest(url: URL(string: "https://smartbazar.kz/api/auth/carts")!)
        request.httpMethod = "GET"
        request.setValue("application/json;charset=UTF-8", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("Bearer" + token!, forHTTPHeaderField: "Authorization")
        URLSession.shared.dataTask(with: request){ data, response, error in
            if let data = data{
                print(data)
                let json = try? JSONDecoder().decode(CartModel.self, from: data)
                self.CartArr = json!.order.items
//                let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String:Any]
//                print(json)
            }
            if let error = error{
                print("Found error! \(error)")
            }
            if let response = response{
                print(response)
            }
        }.resume()
    }
    

}
extension CartViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CartArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CartCell.identifier, for: indexPath) as! CartCell
        let itemsParse = self.CartArr[indexPath.row].product.galleries
        for items in itemsParse{
            let imgLink =  URL(string: items.image)
            cell.imgView.kf.setImage(with: imgLink)
        }
        cell.titleLbl.text = CartArr[indexPath.row].product.title
        cell.measureLbl.text = CartArr[indexPath.row].product.measure.code
        cell.priceLbl.text = "\(CartArr[indexPath.row].price)"
        cell.totalLbl.text = "\(CartArr[indexPath.row].price)"
        totalCountLabel.text = "\(CartArr.count) товаров"
        return cell
    }
    
    
}
