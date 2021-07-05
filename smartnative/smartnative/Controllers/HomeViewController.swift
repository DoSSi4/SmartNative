//
//  HomeViewController.swift
//  smartnative
//
//  Created by DoSSi4 on 30.04.2021.
//

import UIKit
import Kingfisher
import SideMenu

class HomeViewController: UIViewController {
var imageNames = ["1","2","3"]
    var categoryList = [CatalogList](){
        didSet{
            DispatchQueue.main.async {
                self.catCollection.reloadData()
            }

        }
    }
    var popularList = [ItemElement](){
        didSet{
            DispatchQueue.main.async {
                self.popularCollection.reloadData()
            }

        }
    }
    var menu: SideMenuNavigationController?

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
        menu = SideMenuNavigationController(rootViewController: ListOfMenu())
        SideMenuManager.default.leftMenuNavigationController = menu
        SideMenuManager.default.addPanGestureToPresent(toView: self.view)
        menu?.leftSide = true
//        menu?.setNavigationBarHidden(true, animated: false)
        
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
                let json1 = try? JSONDecoder().decode([ItemElement].self, from: data)
                self.popularList = json1!
            }
        }
        task1.resume()
    }
    @IBAction func didTapOnMenu(){
        self.present(menu!, animated: true, completion: nil)
    }
    @IBAction func toLoginFromHome(){
        self.performSegue(withIdentifier: "toLoginFromHome", sender: self)
    }
}
class ListOfMenu: UITableViewController {
    let bazarColor = UIColor(red: 237/255.0, green: 45/255.0, blue: 77/255.0, alpha: 1)
    override func viewDidLoad() {
//        tableView.backgroundColor = .lightGray
        tableView.isScrollEnabled = false
        tableView.tintColor = bazarColor
        tableView.register(UINib(nibName: SideMenuCell.identifier, bundle: nil), forCellReuseIdentifier: "SideMenuCell")
        tableView.separatorStyle = .none
    }
    let menuitems = ["Войти/Зарегистрироваться", "Главная", "Корзина", "Ваши заказы", "FAQ", "О компании", "Доставка", "Политика конфиденциальности"]
    let iconArr = ["person.fill", "house.fill", "cart.fill", "list.bullet", "person.fill.questionmark","info", "car", "shield.checkerboard"]
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuitems.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SideMenuCell", for: indexPath) as! SideMenuCell
        cell.titleLbl.text = menuitems[indexPath.row]
        cell.iconImg.image = UIImage(systemName: iconArr[indexPath.row])
        return cell
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
            let imgUrl = self.popularList[indexPath.row].product.galleries
            var imageLink: URL?
            for imgUrl1 in imgUrl{
                imageLink = URL(string: imgUrl1.image)
            }
            let cell = popularCollection.dequeueReusableCell(withReuseIdentifier: "PopularListCell", for: indexPath) as! PopularListCell
            cell.titleLabel.text = self.popularList[indexPath.row].product.title
            cell.populItemImage.kf.setImage(with: imageLink)
            
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

