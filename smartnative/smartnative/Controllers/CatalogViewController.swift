//
//  CatalogViewController.swift
//  smartnative
//
//  Created by DoSSi4 on 07.05.2021.
//

import UIKit

class CatalogViewController: UIViewController {
    var catalogList = [CatalogList](){
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
        fetchAPI()
    }
    private func fetchAPI(){
        var request: URLRequest = URLRequest(url: URL(string: "https://smartbazar.kz/api/categories")!)
        request.setValue("application/json;charset=UTF-8", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        let task = URLSession.shared.dataTask(with: request){data, respose, error in
            if let error = error{
                print("Something went wrong! \(error)")
            }
            if let data = data{
                let json = try? JSONDecoder().decode([CatalogList].self, from: data)
                self.catalogList = json!
            }
        }
        task.resume()
        
    }

}
extension CatalogViewController: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return catalogList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = self.catalogList[indexPath.row].title
        
        return cell
    }
    
    
}
