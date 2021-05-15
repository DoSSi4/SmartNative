//
//  HomeViewController.swift
//  smartnative
//
//  Created by DoSSi4 on 30.04.2021.
//

import UIKit
import Kingfisher

class HomeViewController: UIViewController {
var imageNames = ["1","2","3"]
    var categoryList = [CatalogList](){
        didSet{
            DispatchQueue.main.async {
                self.catCollection.reloadData()
            }

        }
    }
    var popularList = [Item](){
        didSet{
            DispatchQueue.main.async {
                self.popularCollection.reloadData()
            }

        }
    }

    @IBOutlet weak var imageSlider: UIImageView!
    @IBOutlet weak var catCollection: UICollectionView!
    @IBOutlet weak var popularCollection: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchAPI()
        catCollection.delegate = self
        popularCollection.delegate = self
        catCollection.dataSource = self
        popularCollection.dataSource = self
        catCollection.register(UINib(nibName: "CategoryCell", bundle: nil), forCellWithReuseIdentifier: CategoryCell.identifier)
        popularCollection.register(UINib(nibName: "PopularListCell", bundle: nil), forCellWithReuseIdentifier: PopularListCell.identifier)
        let timer = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: true) { timer in
            self.imageSlider.image = UIImage(named: self.imageNames.randomElement()!)
        }
        timer.fire()
        
}
    @IBAction func ShowAll(){
        self.performSegue(withIdentifier: "ShowAll", sender: self)
        self.hidesBottomBarWhenPushed = false
    }
    private func fetchAPI(){
        var request: URLRequest = URLRequest(url: URL(string: "https://smartbazar.kz/api/categories")!)
        request.setValue("application/json;charset=UTF-8", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        let task = URLSession.shared.dataTask(with: request){data, response, error in
            if let error = error{
                print("Something went wrong! \(error)")
            }
            if let data = data{
                let json = try? JSONDecoder().decode([CatalogList].self, from: data)
                self.categoryList = json!
            }
        }
        task.resume()
        var request1: URLRequest = URLRequest(url: URL(string: "https://smartbazar.kz/api/items")!)
        request1.setValue("application/json;charset=UTF-8", forHTTPHeaderField: "Content-Type")
        request1.setValue("application/json", forHTTPHeaderField: "Accept")
        let task1 = URLSession.shared.dataTask(with: request1){data1, response, error in
            if let error = error{
                print("Error occured! \(error)")
            }
            if let data = data1{
                let json1 = try? JSONDecoder().decode([Item].self, from: data)
                self.popularList = json1!
            }
        }
        task1.resume()
    }
}
extension HomeViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.catCollection{
            return categoryList.count
        }
        return popularList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.catCollection{
        let cell = catCollection.dequeueReusableCell(withReuseIdentifier: "CategoryCell", for: indexPath) as! CategoryCell
            cell.catLabel.text = self.categoryList[indexPath.row].title
        return cell
        }
        else{
//            let imgUrl = URL(string: self.popularList[indexPath.row].product.galleries[])
            let cell = popularCollection.dequeueReusableCell(withReuseIdentifier: "PopularListCell", for: indexPath) as! PopularListCell
            cell.titleLabel.text = self.popularList[indexPath.row].product.title
//            cell.populItemImage.kf.setImage(with: imgUrl)
            return cell
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == self.catCollection{
        return CGSize(width: 128, height: 128)
    }
        else{
            return CGSize(width: 128, height: 128)
        }
    }
}

