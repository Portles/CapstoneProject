//
//  CartViewController.swift
//  CapstoneProject
//
//  Created by Nizamet Özkan on 8.10.2024.
//

import UIKit
import Combine
import FirebaseAuth
import CapstoneProjectData

final public class CartViewController: UIViewController {
    private let viewModel: CartViewModel = CartViewModel()
    
    private var cancellables: Set<AnyCancellable> = []
    
    private let activityIndicator: UIActivityIndicatorView = {
        let activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView(style: .large)
        activityIndicator.backgroundColor = .secondarySystemBackground
        activityIndicator.layer.zPosition = 999
        activityIndicator.layer.opacity = 0.4
        return activityIndicator
    }()
    
    private let tableView: UITableView = {
        let tableView: UITableView = UITableView()
        tableView.register(CartTableViewCell.self, forCellReuseIdentifier: CartTableViewCell.identifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.allowsSelection = false
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
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        bindViewModel()
        
        configureUIElements()
        
        view.addSubview(tableView)
        view.addSubview(totalPriceLabel)
        view.addSubview(totalPriceValueLabel)
        view.addSubview(confirmPurchasesButton)
    }
    
    override public func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        viewModel.getCartItems()
    }
    
    private func bindViewModel() {
        viewModel.$cartProducts
            .receive(on: DispatchQueue.main)
            .sink { [weak self] newValue in
                self?.tableView.reloadData()
                self?.calculatePrice()
                
                if newValue.isEmpty {
                    self?.confirmPurchasesButton.isEnabled = false
                    self?.confirmPurchasesButton.layer.opacity = 0.3
                } else {
                    self?.confirmPurchasesButton.isEnabled = true
                    self?.confirmPurchasesButton.layer.opacity = 1.0
                }
            }
            .store(in: &cancellables)
    }
    
    private func configureUIElements() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.separatorColor = .clear
        
        let confirmButtonAction: UIAction = UIAction(handler: { [weak self] _ in
            if AppleSignInFirebaseAuth.shared.isUserLoggedIn() {
                let alert = UIAlertController(title: "Confirm Purchases", message: "Confirm purchases to proceed", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Confirm", style: UIAlertAction.Style.default, handler: { _ in
                    self?.viewModel.confirmPurchases()
                }))
                alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.destructive, handler: nil))
                self?.present(alert, animated: true, completion: nil)
            } else {
                self?.navigationController?.tabBarController?.selectedIndex = 2
            }
        })
        
        confirmPurchasesButton.addAction(confirmButtonAction, for: .touchUpInside)
        
        NotificationCenter.default.addObserver(self, selector: #selector(performingSomethingChanged), name: .performingSomethingChanged, object: nil)
        
        view.addSubview(activityIndicator)
    }
    
    @objc private func performingSomethingChanged() {
        let isLoading = viewModel.performingSomething
        activityIndicator.isHidden = !isLoading
        if isLoading {
            activityIndicator.startAnimating()
            view.isUserInteractionEnabled = false
        } else {
            activityIndicator.stopAnimating()
            view.isUserInteractionEnabled = true
        }
    }
    
    override public func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        activityIndicator.center = view.center
        activityIndicator.frame = view.bounds
        
        NSLayoutConstraint.activate([
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
            
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
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
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        146
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.cartProducts.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: CartTableViewCell = tableView.dequeueReusableCell(withIdentifier: CartTableViewCell.identifier, for: indexPath) as! CartTableViewCell
        let cartItem: CartProduct = viewModel.cartProducts[indexPath.row]
        
        cell.delegate = self
        cell.index = indexPath
        
        cell.configure(imageName: cartItem.image, name: cartItem.name, price: cartItem.price, count: cartItem.orderCount)
        
        return cell
    }
}

extension CartViewController: CartTableViewCellDelegate {
    func didTapRemoveButton(_ index: IndexPath) {
        let cartItem: CartProduct = viewModel.cartProducts[index.row]
        
        viewModel.removeCartItem(cartItem)
    }
}

extension CartViewController: AppleSignInDelegate {
    public func appleSignInDidComplete(user: FirebaseAuth.User) {
        self.dismiss(animated: true)
    }
    
    public func appleSignInDidFail(error: any Error) {
        debugPrint(error.localizedDescription)
    }
}
