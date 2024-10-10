//
//  CartViewController.swift
//  CapstoneProject
//
//  Created by Nizamet Özkan on 8.10.2024.
//

import UIKit
import Combine

final class CartViewController: UIViewController {
    private let viewModel: CartViewModel = CartViewModel()
    
    private var cancellables: Set<AnyCancellable> = []
    
    private let labelTitle: UILabel = {
        let label: UILabel = UILabel()
        label.text = "My Cart"
        label.textAlignment = .center
        label.font = .systemFont(ofSize: .init(24), weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let dismissButton: UIButton = {
        let button: UIButton = UIButton(type: .custom)
        button.setImage(UIImage(systemName: "multiply.circle.fill"), for: .normal)
        button.layer.cornerRadius = 10
        button.tintColor = .systemGray5
        button.imageView?.layer.transform = CATransform3DMakeScale(2, 2, 2)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.clipsToBounds = true
        return button
    }()
    
    private let tableView: UITableView = {
        let tableView: UITableView = UITableView()
        tableView.register(CartTableViewCell.self, forCellReuseIdentifier: CartTableViewCell.identifier)
        tableView.separatorStyle = .none
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private let totalPriceLabel: UILabel = {
        let label: UILabel = UILabel()
        label.text = "Total:"
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let totalPriceValueLabel: UILabel = {
        let label: UILabel = UILabel()
        label.text = "000$"
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let confirmPurchasesButton: UIButton = {
        let button: UIButton = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Confirm Purchases", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemOrange
        button.layer.cornerRadius = 10
        button.layer.opacity = 0.3
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        bindViewModel()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        let dismissButtonAction: UIAction = UIAction(handler: { [unowned self] _ in
            self.dismiss(animated: true, completion: nil)
        })
        
        dismissButton.addAction(dismissButtonAction, for: .touchUpInside)
        
        view.addSubview(labelTitle)
        view.addSubview(dismissButton)
        view.addSubview(tableView)
        view.addSubview(totalPriceLabel)
        view.addSubview(totalPriceValueLabel)
        view.addSubview(confirmPurchasesButton)
    }
    
    private func bindViewModel() {
        viewModel.$cartProducts
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.tableView.reloadData()
                self?.calculatePrice()
            }
            .store(in: &cancellables)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        NSLayoutConstraint.activate([
            labelTitle.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            labelTitle.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            labelTitle.widthAnchor.constraint(equalToConstant: 120),
            
            dismissButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            dismissButton.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            dismissButton.widthAnchor.constraint(equalToConstant: 50),
            dismissButton.heightAnchor.constraint(equalToConstant: 50),
            
            confirmPurchasesButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            confirmPurchasesButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            confirmPurchasesButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            confirmPurchasesButton.heightAnchor.constraint(equalToConstant: 64),
            
            totalPriceLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            totalPriceLabel.widthAnchor.constraint(equalToConstant: 100),
            totalPriceLabel.bottomAnchor.constraint(equalTo: confirmPurchasesButton.topAnchor, constant: -20),
            
            totalPriceValueLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            totalPriceValueLabel.widthAnchor.constraint(equalToConstant: 100),
            totalPriceValueLabel.bottomAnchor.constraint(equalTo: confirmPurchasesButton.topAnchor, constant: -20),
            
            tableView.topAnchor.constraint(equalTo: labelTitle.bottomAnchor, constant: 20),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: totalPriceLabel.topAnchor, constant: -20)
        ])
    }
    
    private func calculatePrice() {
        totalPriceValueLabel.text = viewModel.calculateTotal()
    }
}

extension CartViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        146
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.cartProducts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: CartTableViewCell = tableView.dequeueReusableCell(withIdentifier: CartTableViewCell.identifier, for: indexPath) as! CartTableViewCell
        let cartItem: CartProduct = viewModel.cartProducts[indexPath.row]
        
        cell.delegate = self
        
        cell.configure(cartId: cartItem.cartId, imageName: cartItem.image, name: cartItem.name, price: cartItem.price, count: cartItem.orderCount)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
}

extension CartViewController: CartTableViewCellDelegate {
    func didTapRemoveButton(_ cartId: Int) {
        viewModel.removeCartItem(cartId)
    }
}
