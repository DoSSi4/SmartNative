//
//  CategoryViewController.swift
//  smartnative
//
//  Created by DoSSi4 on 16.05.2021.
//

import UIKit

class CategoryViewController: UIViewController {
    @IBOutlet var collectionView: UICollectionView!
    var productList: [Product] = [Product](){
        didSet{
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchAPI()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: ProductCell.identifier, bundle: nil), forCellWithReuseIdentifier: ProductCell.identifier)
    }
    @IBAction func backToCategories(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    private func fetchAPI(){
        var request: URLRequest = URLRequest(url: URL(string: "https://smartbazar.kz/api/products")!)
        request.setValue("application/json;charset=UTF-8", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        let task = URLSession.shared.dataTask(with: request){data, respose, error in
            if let error = error{
                print("Something went wrong! \(error)")
            }
            if let data = data{
                let json = try? JSONDecoder().decode([Product].self, from: data)
                self.productList = json!
                
            }
        }
        task.resume()
    }

}
extension CategoryViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return productList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductCell", for: indexPath) as! ProductCell
        cell.prodTitle.text = productList[indexPath.row].title
        let imgUrl = self.productList[indexPath.row].galleries
        var imageLink: URL?
        for imgUrl1 in imgUrl{
            imageLink = URL(string: imgUrl1.image)
        }
        cell.prodImg.kf.setImage(with: imageLink)
        let priceparse = self.productList[indexPath.row].items
        for price in priceparse{
            cell.prodPrice.text = "\(price.price)"
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 200, height: 200)
    }
    
    
}
