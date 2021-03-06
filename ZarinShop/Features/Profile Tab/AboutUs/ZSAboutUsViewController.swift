//
//  ZSAboutUsViewController.swift
//  ZarinShop
//
//  Created by Murad Ibrohimov on 05/12/20.
//  Copyright © 2020 ZarinShop. All rights reserved.
//

import UIKit

class ZSAboutUsViewController: ZSBaseViewController {
    
    //MARK: - Public variables
    
    var selectedAddressHandler: ((AddressModel) -> ())?
    
    //MARK: - Private variables
    
    private let cellIdentifier = "ZSAboutUsCell"
    private var data: [ZSAboutUsSection] = [.info, .socials]
    
    //MARK: - GUI variables
    
    lazy var tableView: UITableView = {
        var tableView = UITableView(frame: .zero, style: .grouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        //tableView.separatorInset.left = 0
        return tableView
    }()
    
    //MARK: - View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "О нас"
        addSubviews()
        makeConstraints()
    }
    
    //MARK: - Constraints
    
    private func makeConstraints() {
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    //MARK: - Setters
    
    private func addSubviews() {
        view.addSubview(tableView)
    }
    
    //MARK: - Heplers
    
    func imageWithImage(image: UIImage?, scaledToSize newSize: CGSize) -> UIImage {
        guard let image = image else { return UIImage() }
        UIGraphicsBeginImageContext( newSize )
        image.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!.withRenderingMode(.alwaysTemplate)
    }
    
}

extension ZSAboutUsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return data[section].title
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data[section].items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        
        let model = data[indexPath.section].items[indexPath.row]
        
        cell.textLabel?.text = model.title
        cell.textLabel?.font = .systemFont(ofSize: 15, weight: .regular)
        
        cell.imageView?.tintColor = .black
        cell.imageView?.image = model.image
 
        cell.selectionStyle = .gray
        let selectedBackgroungView = UIView()
        selectedBackgroungView.backgroundColor = .selectionCellBG
        cell.selectedBackgroundView = selectedBackgroungView
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let item = data[indexPath.section].items[indexPath.row]
        if let shortLink = item.shortLink,
           let url = URL(string: shortLink),
           UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        } else if let link = item.link,
                  let url = URL(string: link),
                  UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }
    
}
