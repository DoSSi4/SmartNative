//
//  HomeViewController.swift
//  smartnative
//
//  Created by DoSSi4 on 30.04.2021.
//

import UIKit

class HomeViewController: UIViewController {
var imageNames = ["1","2","3"]
    @IBOutlet weak var imageSlider: UIImageView!
    @IBOutlet weak var catCollection: UICollectionView!
    @IBOutlet weak var popularCollection: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
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
}
extension HomeViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       let cell = popularCollection.dequeueReusableCell(withReuseIdentifier: "PopularListCell", for: indexPath)
        catCollection.dequeueReusableCell(withReuseIdentifier: "CategoryCell", for: indexPath)
        return cell
    }
    
    
}
