//
//  WishlistViewController.swift
//  smartnative
//
//  Created by DoSSi4 on 25.05.2021.
//

import UIKit
import Kingfisher

class WishlistViewController: UIViewController {
    var wishlistArray: [WishlistElement] = [WishlistElement](){
        didSet{
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
   private let refreshControl = UIRefreshControl()
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: WishlistCell.identifier, bundle: nil), forCellReuseIdentifier: WishlistCell.identifier)
        fetchAPI()
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
           tableView.addSubview(refreshControl)
    
    }
    @objc func refresh(_ sender: AnyObject){
        fetchAPI()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let defaults = UserDefaults.standard
        if defaults.bool(forKey: "isLoggedIn") == false{
            self.performSegue(withIdentifier: "LoginView", sender: self)
            print(UserDefaults.standard.bool(forKey: "isLoggedIn"))
        }

    }
    private func fetchAPI(){
        let token = UserDefaults.standard.string(forKey: "token")
        var request: URLRequest = URLRequest(url: URL(string: "https://smartbazar.kz/api/auth/wishlists")!)
        request.httpMethod = "GET"
        request.setValue("application/json;charset=UTF-8", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("Bearer " + token!, forHTTPHeaderField: "Authorization")
        URLSession.shared.dataTask(with: request){ data,response,error in
            if let error = error{
            print(error)
            }
            if let data = data {
                let json = try? JSONDecoder().decode([WishlistElement].self, from: data)
                self.wishlistArray = json!
                
            }
        }.resume()
        refreshControl.endRefreshing()
    }

}
extension WishlistViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return wishlistArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let imgUrl = wishlistArray[indexPath.row].item.product.galleries
        var imgLink: URL?
        let cell = tableView.dequeueReusableCell(withIdentifier: WishlistCell.identifier, for: indexPath) as! WishlistCell
        for imgUrl1 in imgUrl{
            imgLink = URL(string: imgUrl1.image)
        }
        cell.productImg.kf.setImage(with: imgLink)
        cell.titleLabel.text = wishlistArray[indexPath.row].item.product.title
        return cell
    }
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let token = UserDefaults.standard.string(forKey: "token")
        var request: URLRequest = URLRequest(url: URL(string: "https://smartbazar.kz/api/auth/wishlist/unlike/\(wishlistArray[indexPath.row].item_id)")!)
        request.httpMethod = "DELETE"
        request.setValue("application/json;charset=UTF-8", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("Bearer " + token!, forHTTPHeaderField: "Authorization")
        print(token!)
       
        let unlikeAction = UIContextualAction(style: .destructive, title: "Удалить из избранного") { action, view, handler in
            URLSession.shared.dataTask(with: request){data, response, error in
                if let response = response as? HTTPURLResponse{
                    if response.statusCode == 200{
                            self.wishlistArray.remove(at: indexPath.row)
//                            tableView.deleteRows(at: [indexPath], with: .bottom)
                    }
                }
            }.resume()
    }
        unlikeAction.backgroundColor = .red
        let configuration = UISwipeActionsConfiguration(actions: [unlikeAction])
                return configuration
        
    }
}
