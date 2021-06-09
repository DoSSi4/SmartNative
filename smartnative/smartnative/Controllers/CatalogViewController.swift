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
                self.filteredData = self.catalogList
                self.tableView.reloadData()
            }
            
        }
    }
    var filteredData: [CatalogList]!
    
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: CatalogCell.identifier, bundle: nil), forCellReuseIdentifier: CatalogCell.identifier)
        fetchAPI()
        filteredData = catalogList
    }
    @IBAction func showLogin(_ sender: Any)
    {
        self.performSegue(withIdentifier: "ShowLogin", sender: self)
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
        return filteredData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CatalogCell.identifier, for: indexPath) as! CatalogCell
        cell.catalogLabel.text = self.filteredData[indexPath.row].title
        return cell
        }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        tableView.deselectRow(at: indexPath, animated: false)
        self.performSegue(withIdentifier: "openCategory", sender: self)
    }
    
    
}
extension CatalogViewController: UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredData = []
        if searchText == ""{
            filteredData = catalogList
        }
            for category in catalogList{
                if category.title.lowercased().contains(searchText.lowercased()){
                    filteredData.append(category)
                }
                }
            
        self.tableView.reloadData()
        }
}
