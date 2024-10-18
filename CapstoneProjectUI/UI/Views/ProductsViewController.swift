//
//  ViewController.swift
//  CapstoneProject
//
//  Created by Nizamet Özkan on 6.10.2024.
//

import UIKit
import Combine
import CapstoneProjectData

final public class ProductsViewController: UIViewController {
    private let viewModel: ProductsViewModel = ProductsViewModel()
    
    private let collectionViewSegmentControl: UISegmentedControl = {
        let items = ["Small", "Large"]
        let segmentedControl = UISegmentedControl(items: items)
        segmentedControl.selectedSegmentIndex = 0
        return segmentedControl
    }()

    private var collectionView: UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        
        let screenSize = (UIScreen.main.bounds.width - 30) / 2
        
        let itemSize = CGSize(width: screenSize, height: screenSize * 1.2)
        
        layout.itemSize = itemSize
        
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.register(ProductCollectionViewCell.self, forCellWithReuseIdentifier: ProductCollectionViewCell.identifier)
        collectionView.backgroundColor = .clear
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private var cancellables: Set<AnyCancellable> = []
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUIElements()
        
        bindViewModel()
    }
    
    private func configureUIElements() {
        view.backgroundColor = .secondarySystemBackground
        
        collectionViewSegmentControl.addTarget(self, action: #selector(didSegmentValueChanged(_:)), for: .valueChanged)
        let segmentItem = UIBarButtonItem(customView: collectionViewSegmentControl)
        navigationItem.rightBarButtonItem = segmentItem
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.dragDelegate = self
        collectionView.dropDelegate = self
        
        collectionView.dragInteractionEnabled = true
        
        view.addSubview(collectionView)
    }
    
    private func bindViewModel() {
        viewModel.$products
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.collectionView.reloadData()
            }
            .store(in: &cancellables)
    }
    
    @objc func didSegmentValueChanged(_ sender: UISegmentedControl) {
        let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout
        var newSize: CGSize
        let screenSize = (view.width - 30) / 2
        
        switch sender.selectedSegmentIndex {
        case 0:
            newSize = CGSize(width: screenSize, height: screenSize * 1.2)
        case 1:
            newSize = CGSize(width: view.width, height: view.width * 0.5)
        default:
            newSize = CGSize(width: screenSize, height: screenSize * 1.2)
        }
        
        UIView.animate(withDuration: 0.3) {
            layout?.itemSize = newSize
            self.collectionView.collectionViewLayout.invalidateLayout()
        }
    }
    
    @IBAction func didTapCartButton(_ sender: Any) {
        let viewController: CartViewController = CartViewController()
        viewController.modalPresentationStyle = .fullScreen
        present(viewController, animated: true)
    }
    
    override public func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
}

extension ProductsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.products.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let product: Product = viewModel.products[indexPath.row]
        
        let cell: ProductCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductCollectionViewCell.identifier, for: indexPath) as! ProductCollectionViewCell
        
        cell.configure(name: product.name, price: product.price, imageName: product.image)
        
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let product: Product = viewModel.products[indexPath.row]
        
        let viewController: ProductDetailViewController = ProductDetailViewController(product: product)
        
        viewController.modalPresentationStyle = .fullScreen
        
        present(viewController, animated: true, completion: nil)
    }
}

extension ProductsViewController: UICollectionViewDragDelegate {
    public func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        let product = viewModel.products[indexPath.row]
        let itemProvider = NSItemProvider(object: product.name as NSString)
        let dragItem = UIDragItem(itemProvider: itemProvider)
        dragItem.localObject = product
        return [dragItem]
    }
}

extension ProductsViewController: UICollectionViewDropDelegate {
    public func collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate session: any UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal {
        if collectionView.hasActiveDrag {
            return UICollectionViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
        }
        return UICollectionViewDropProposal(operation: .forbidden)
    }
    
    public func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
        guard let destinationIndexPath = coordinator.destinationIndexPath else { return }
        
        for item in coordinator.items {
            if let sourceIndexPath = item.sourceIndexPath, let product = item.dragItem.localObject as? Product {
                viewModel.reArrangeProduct(sourceIndexPath, destinationIndexPath, product)
                
                collectionView.performBatchUpdates({
                    collectionView.deleteItems(at: [sourceIndexPath])
                    collectionView.insertItems(at: [destinationIndexPath])
                })
                coordinator.drop(item.dragItem, toItemAt: destinationIndexPath)
            }
        }
    }
}
