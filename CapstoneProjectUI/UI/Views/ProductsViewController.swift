//
//  ViewController.swift
//  CapstoneProject
//
//  Created by Nizamet Özkan on 6.10.2024.
//

import UIKit
import CapstoneProjectData

public protocol ProductsViewControllerInterface: AnyObject {
    func configureUIElements()
    func setConstraints()
    func reloadCollectionViewData()
}

final public class ProductsViewController: UIViewController {
    private let viewModel: ProductsViewModelInterface
    private let main: DispatchQueueInterface
    
    private let collectionViewSegmentControl: UISegmentedControl = {
        let items = ["Small", "Large"]
        let segmentedControl = UISegmentedControl(items: items)
        segmentedControl.selectedSegmentIndex = 0
        return segmentedControl
    }()
    
    private let collectionView: UICollectionView = {
        
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
        collectionView.dragInteractionEnabled = true
        
        return collectionView
    }()
    
    public init(viewModel: ProductsViewModelInterface, main: DispatchQueueInterface) {
        self.viewModel = viewModel
        self.main = main
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.viewDidLoad()
    }
    
    @objc func didSegmentValueChanged(_ sender: UISegmentedControl) {
        let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout
        var newSize: CGSize
        let screenSize = (view.width - 30) / 2
        
        switch sender.selectedSegmentIndex {
        case 0:
            newSize = CGSize(width: screenSize, height: screenSize * 1.2)
        case 1:
            newSize = CGSize(width: view.width * 0.95, height: view.width * 0.5)
        default:
            newSize = CGSize(width: screenSize, height: screenSize * 1.2)
        }
        
        UIView.animate(withDuration: 0.3) {
            layout?.itemSize = newSize
            self.collectionView.collectionViewLayout.invalidateLayout()
        }
    }
    
    override public func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        viewModel.viewDidLayoutSubviews()
    }
}

extension ProductsViewController: ProductsViewControllerInterface {
    
    public func reloadCollectionViewData() {
        main.async { [weak self] in
            self?.collectionView.reloadData()
        }
    }
    
    public func configureUIElements() {
        view.backgroundColor = .secondarySystemBackground
        
        collectionViewSegmentControl.addTarget(self, action: #selector(didSegmentValueChanged(_:)), for: .valueChanged)
        
        let segmentItem = UIBarButtonItem(customView: collectionViewSegmentControl)
        navigationItem.rightBarButtonItem = segmentItem
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.dragDelegate = self
        collectionView.dropDelegate = self
        
        view.addSubview(collectionView)
    }
    
    public func setConstraints() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
}

extension ProductsViewController: UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let product = viewModel.getProduct(index: indexPath.row) else { return }
        guard let viewController = viewModel.getProductDetailView(product: product) else { return }
        present(viewController, animated: true, completion: nil)
    }
}

extension ProductsViewController: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.productCount
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let product = viewModel.getProduct(index: indexPath.row) else { return UICollectionViewCell() }
        let cell: ProductCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductCollectionViewCell.identifier, for: indexPath) as! ProductCollectionViewCell
        
        cell.configure(name: product.name, price: product.price, imageName: product.image)
        
        Task.detached { [weak self] in
            let imageData = await self?.viewModel.getProductImage(product.image)
            
            return await MainActor.run {
                cell.setImage(imageData)
            }
        }
        
        return cell
    }
}

extension ProductsViewController: UICollectionViewDragDelegate {
    public func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        guard let product = viewModel.getProduct(index: indexPath.row) else { return [] }
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
