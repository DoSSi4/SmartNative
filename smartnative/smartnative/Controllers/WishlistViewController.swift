//
//  WishlistViewController.swift
//  smartnative
//
//  Created by DoSSi4 on 25.05.2021.
//

import UIKit

class WishlistViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let defaults = UserDefaults.standard
        if defaults.bool(forKey: "isLoggedIn") == false{
            self.performSegue(withIdentifier: "LoginView", sender: nil)
        }
    }

}
//extension WishlistViewController: UITableViewDelegate, UITableViewDataSource{
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        <#code#>
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        <#code#>
//    }
//
//
    
//}
