//
//  LoggedInView.swift
//  CapstoneProject
//
//  Created by Nizamet Özkan on 15.10.2024.
//

import UIKit
import FirebaseAuth
import CapstoneProjectData

protocol LoggedInViewDelegate: AnyObject {
    func didTapBuyButton()
    func logoutButtonTapped()
}

final class LoggedInView: UIView {
    private var lastPurchases: [CartProduct]?
    
    private let logoutButton: UIButton = {
        let button = UIButton()
        button.setTitle("Logout", for: .normal)
        button.setTitleColor(.red, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let emailKeyLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.numberOfLines = 0
        label.text = "Email:"
        label.font = .preferredFont(forTextStyle: .headline)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let emailLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.numberOfLines = 0
        label.font = .preferredFont(forTextStyle: .subheadline)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let nameKeyLabel: UILabel = {
       let label = UILabel()
        label.textColor = .label
        label.text = "Name:"
        label.font = .preferredFont(forTextStyle: .headline)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let nameLabel: UILabel = {
       let label = UILabel()
        label.textColor = .label
        label.font = .preferredFont(forTextStyle: .subheadline)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let buyHistoryLabel: UILabel = {
       let label = UILabel()
        label.textColor = .label
        label.text = "Latest Purchase"
        label.font = .preferredFont(forTextStyle: .extraLargeTitle)
        label.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let tableView: UITableView = {
       let tableView = UITableView()
        tableView.register(LatestPurchasesTableViewCell.self, forCellReuseIdentifier: LatestPurchasesTableViewCell.identifier)
        tableView.allowsSelection = false
        tableView.isHidden = true
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private let noLatestPurchaseview: NoLatestPurchaseView = {
        let view = NoLatestPurchaseView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    weak var delegate: LoggedInViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        noLatestPurchaseview.delegate = self
        
        let logoutButtonAction: UIAction = UIAction { [weak self] _ in
            if AppleSignInFirebaseAuth.shared.logOutUser() {
                self?.delegate?.logoutButtonTapped()
            }
        }
        
        logoutButton.addAction(logoutButtonAction, for: .touchUpInside)
        
        [logoutButton, emailLabel, emailKeyLabel, nameLabel, nameKeyLabel, buyHistoryLabel, tableView, noLatestPurchaseview].forEach(addSubview)
        
        getLatestPurchase()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func configure(with user: UserModel) {
        emailLabel.text = user.email
        nameLabel.text = user.fullName
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        tableView.separatorStyle = .none
        tableView.separatorColor = .clear
        
        NSLayoutConstraint.activate([
            logoutButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            logoutButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            logoutButton.widthAnchor.constraint(equalToConstant: 75),
            logoutButton.heightAnchor.constraint(equalToConstant: 16),
            
            nameKeyLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            nameKeyLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            nameKeyLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            
            nameLabel.topAnchor.constraint(equalTo: nameKeyLabel.bottomAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            nameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            
            emailKeyLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 20),
            emailKeyLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            emailKeyLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            
            emailLabel.topAnchor.constraint(equalTo: emailKeyLabel.bottomAnchor),
            emailLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            emailLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            
            buyHistoryLabel.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: 20),
            buyHistoryLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            buyHistoryLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            
            tableView.topAnchor.constraint(equalTo: buyHistoryLabel.bottomAnchor, constant: 10),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            noLatestPurchaseview.topAnchor.constraint(equalTo: buyHistoryLabel.bottomAnchor, constant: 10),
            noLatestPurchaseview.leadingAnchor.constraint(equalTo: leadingAnchor),
            noLatestPurchaseview.trailingAnchor.constraint(equalTo: trailingAnchor),
            noLatestPurchaseview.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    func getLatestPurchase() {
        FirebaseManager.fetchBuyHistories { [weak self] model, error in
            guard error == nil else {
                self?.buyHistoryLabel.isHidden = true
                self?.noLatestPurchaseview.isHidden = false
                self?.tableView.isHidden = true
                debugPrint(error?.localizedDescription ?? "Fetch buy histories error")
                return
            }
            
            if let model {
                self?.buyHistoryLabel.isHidden = false
                self?.noLatestPurchaseview.isHidden = true
                self?.lastPurchases = model.buyyedProducts
                self?.tableView.isHidden = false
                self?.tableView.reloadData()
            }
        }
    }
}

extension LoggedInView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 146
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lastPurchases?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let data = lastPurchases?[indexPath.row] {
            let cell = tableView.dequeueReusableCell(withIdentifier: LatestPurchasesTableViewCell.identifier, for: indexPath) as! LatestPurchasesTableViewCell
            
            cell.configure(imageName: data.image, name: data.name, price: data.price, count: data.orderCount)
            
            return cell
        } else {
            return UITableViewCell()
        }
    }
}

extension LoggedInView: NoLatestPurchaseViewDelegate {
    func goBuyButtonTapped() {
        delegate?.didTapBuyButton()
    }
}
