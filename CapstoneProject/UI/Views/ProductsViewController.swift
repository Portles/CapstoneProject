//
//  ViewController.swift
//  CapstoneProject
//
//  Created by Nizamet Özkan on 6.10.2024.
//

import UIKit
import Combine

final class ProductsViewController: UIViewController {
    private let viewModel: ProductsViewModel = ProductsViewModel()

    @IBOutlet weak var collectionView: UICollectionView!
    
    private var cancellables: Set<AnyCancellable> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let layout = UICollectionViewFlowLayout()
        
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        
        let screenSize = (UIScreen.main.bounds.width - 30) / 2
        
        let itemSize = CGSize(width: screenSize, height: screenSize * 1.2)
        
        layout.itemSize = itemSize
        
        collectionView.collectionViewLayout = layout
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        bindViewModel()
    }
    
    private func bindViewModel() {
        viewModel.$products
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.collectionView.reloadData()
            }
            .store(in: &cancellables)
    }
}

extension ProductsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.products.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let product: Product = viewModel.products[indexPath.row]
        
        let cell: ProductCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductCollectionViewCell", for: indexPath) as! ProductCollectionViewCell
        
        cell.configure(name: product.name, price: product.price, imageName: product.image)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let product: Product = viewModel.products[indexPath.row]
        
        let viewController: ProductDetailViewController = ProductDetailViewController(product: product)
        
        viewController.modalPresentationStyle = .fullScreen
        
        present(viewController, animated: true, completion: nil)
    }
}
