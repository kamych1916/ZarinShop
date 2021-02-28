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
    private var data: [ZSAboutUsSectionModel] = [
        .init(title: "Основная информация", items: [
                .init(name: "Ташкент , улица Катта Дархан, дом 23", image: UIImage(named: "location")),
                .init(name: "zarinshop@mail.ru", image: UIImage(named: "mail")),
                .init(name: "+998 (71) 150-00-02", image: UIImage(named: "phone")),
                .init(name: "Прием звонков: с 9:00 до 20:00 (Пн-Пт)", image: UIImage(named: "clock"))]),
        
        .init(title: "Социальные сети", items: [
                .init(name: "Instagram", image: UIImage(named: "instagram")),
                .init(name: "Facebook", image: UIImage(named: "facebook")),
                .init(name: "Telegram", image: UIImage(named: "telegram"))]),
    ]
    
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
        
        cell.textLabel?.text = model.name
        cell.textLabel?.font = .systemFont(ofSize: 15, weight: .regular)
        
        cell.imageView?.tintColor = .black
        cell.imageView?.image = model.image //imageWithImage(image: model.image, scaledToSize: CGSize(width: 24, height: 24))
 
        cell.selectionStyle = .gray
        let selectedBackgroungView = UIView()
        selectedBackgroungView.backgroundColor = .selectionCellBG
        cell.selectedBackgroundView = selectedBackgroungView
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
}
