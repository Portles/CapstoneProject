//
//  CartViewController.swift
//  CapstoneProject
//
//  Created by Nizamet Özkan on 8.10.2024.
//

import UIKit
import FirebaseAuth
import CapstoneProjectData

public protocol CartViewControllerInterface: AnyObject, Errorable, Alertable {
    func configureUIElements()
    func showConfirmPurchasesAlert()
    func reloadTableView()
    func setContraints()
    func setButtonsEnability(state: Bool, opacity: Float)
}

final public class CartViewController: UIViewController {
    private let viewModel: CartViewModelInterface
    private let main: DispatchQueueInterface
    
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
    
    public init(viewModel: CartViewModelInterface,
                main: DispatchQueueInterface) {
        self.viewModel = viewModel
        self.main = main
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        viewModel.viewDidLoad()
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.viewDidAppear()
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        viewModel.viewDidLayoutSubviews()
    }
}

extension CartViewController: CartViewControllerInterface {
    public func reloadTableView() {
        main.async { [weak self] in
            self?.tableView.reloadData()
        }
    }
    
    public func configureUIElements() {
        view.backgroundColor = .systemBackground
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.separatorColor = .clear
        
        let confirmButtonAction: UIAction = UIAction(handler: { [weak self] _ in
            if AppleSignInFirebaseAuth.shared.isUserLoggedIn() {
                self?.showConfirmPurchasesAlert()
            } else {
                self?.navigationController?.tabBarController?.selectedIndex = 2
            }
        })
        
        confirmPurchasesButton.addAction(confirmButtonAction, for: .touchUpInside)
        
        view.addSubview(activityIndicator)
        view.addSubview(tableView)
        view.addSubview(totalPriceLabel)
        view.addSubview(totalPriceValueLabel)
        view.addSubview(confirmPurchasesButton)
    }
    
    public func showConfirmPurchasesAlert() {
        let alert = UIAlertController(title: "Confirm Purchases", message: "Confirm purchases to proceed", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Confirm", style: UIAlertAction.Style.default, handler: { [weak self] _ in
            self?.viewModel.saveUserPurchases()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.destructive, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    private func setPriceLabel() {
        totalPriceValueLabel.text = viewModel.total
    }
    
    public func setContraints() {
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
    
    public func setButtonsEnability(state: Bool, opacity: Float) {
        main.async { [weak self] in
            guard let self else { return }
            confirmPurchasesButton.isEnabled = state
            confirmPurchasesButton.layer.opacity = opacity
        }
    }
}

extension CartViewController: UITableViewDelegate, UITableViewDataSource {
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        viewModel.cellLenght
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.cartProductCount
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cartItem: CartProduct = viewModel.getCartItem(indexPath.row) else { return UITableViewCell() }
        
        let cell: CartTableViewCell = tableView.dequeueReusableCell(withIdentifier: CartTableViewCell.identifier, for: indexPath) as! CartTableViewCell
        cell.delegate = self
        cell.setIndex(indexPath)
        cell.configure(imageName: cartItem.image, name: cartItem.name, price: cartItem.price, count: cartItem.orderCount)
        
        Task.detached {
            do {
                let image = await self.viewModel.getImage(cartItem.image)
                
                return await MainActor.run {
                    cell.setImage(image)
                }
            }
        }
        
        return cell
    }
}

extension CartViewController: CartTableViewCellDelegate {
    func didTapRemoveButton(_ index: IndexPath) {
        guard let cartItem: CartProduct = viewModel.getCartItem(index.row) else { return }
        
        viewModel.removeCartItem(cartItem)
    }
}
