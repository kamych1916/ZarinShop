//
//  ZSAddCardViewController.swift
//  ZarinShop
//
//  Created by Humo Programmer  on 10/16/20.
//  Copyright © 2020 Murad Ibrohimov. All rights reserved.
//

import UIKit

class ZSAddCardViewController: UIViewController {
    
    //MARK: - Public variables
    
    var dismissHandler: (() -> Void)?
    
    //MARK: - Private variables
    
    private var sectionSize: CGSize {
        return CGSize(width: self.view.bounds.width / 1.2, height: 60)
    }
    
    //MARK: - GUI variables
    
    private lazy var titleLabel: UILabel = {
        var label = UILabel()
        label.text = "Добавить новую карту"
        label.textColor = AppColors.textDarkColor.color()
        label.font = .systemFont(ofSize: 20, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var scrollView: UIScrollView = {
        var scroll = UIScrollView()
        scroll.clipsToBounds = true
        scroll.isScrollEnabled = true
        scroll.isUserInteractionEnabled = true
        scroll.translatesAutoresizingMaskIntoConstraints = false
        return scroll
    }()
    
    private lazy var mainView: UIView = {
        var view = UIView()
        view.clipsToBounds = true
        view.layer.cornerRadius = 20
        view.backgroundColor = AppColors.mainLightColor.color()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var cardView: UIView = {
        var view = UIView()
        view.clipsToBounds = true
        view.layer.cornerRadius = 20
        view.backgroundColor = AppColors.mainColor.color()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var cartCVCView: UIView = {
        var view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 20
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var cartCVCLable: UILabel = {
        var label = UILabel()
        label.text = "123"
        label.textColor = AppColors.textDarkColor.color()
        label.font = .systemFont(ofSize: 17, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var cartNumberLable: UILabel = {
        var label = UILabel()
        label.text = "***********1234"
        label.textColor = AppColors.textGoldColor.color()
        label.font = .systemFont(ofSize: 17, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var cartNameLable: UILabel = {
        var label = UILabel()
        label.text = "NAME SURNAME"
        label.textColor = AppColors.textGoldColor.color()
        label.font = .systemFont(ofSize: 20, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var cartDateLable: UILabel = {
        var label = UILabel()
        label.text = "09/22"
        label.textColor = AppColors.textDarkColor.color()
        label.font = .systemFont(ofSize: 17, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var cartCVCField: UITextField = {
        var field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.borderStyle = .none
        field.layer.cornerRadius = 20
        field.backgroundColor = .white
        field.textColor = AppColors.textDarkColor.color()
        field.leftView = UIView(frame: .init(x: 0, y: 0, width: 20, height: 10))
        field.leftViewMode = .always
        field.placeholder = "CVC код"
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()
    
    private lazy var cartNumberField: UITextField = {
        var field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.borderStyle = .none
        field.layer.cornerRadius = 20
        field.backgroundColor = .white
        field.textColor = AppColors.textDarkColor.color()
        field.leftView = UIView(frame: .init(x: 0, y: 0, width: 20, height: 10))
        field.leftViewMode = .always
        field.placeholder = "Номер карты"
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()
    
    private lazy var cartNameField: UITextField = {
        var field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.borderStyle = .none
        field.layer.cornerRadius = 20
        field.backgroundColor = .white
        field.textColor = AppColors.textDarkColor.color()
        field.leftView = UIView(frame: .init(x: 0, y: 0, width: 20, height: 10))
        field.leftViewMode = .always
        field.placeholder = "Имя и фамилия"
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()
    
    private lazy var cartDateYearField: UITextField = {
        var field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.borderStyle = .none
        field.layer.cornerRadius = 20
        field.backgroundColor = .white
        field.textColor = AppColors.textDarkColor.color()
        field.leftView = UIView(frame: .init(x: 0, y: 0, width: 20, height: 10))
        field.leftViewMode = .always
        field.placeholder = "Год"
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()
    
    private lazy var cartDateMonthField: UITextField = {
        var field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.borderStyle = .none
        field.layer.cornerRadius = 20
        field.backgroundColor = .white
        field.textColor = AppColors.textDarkColor.color()
        field.leftView = UIView(frame: .init(x: 0, y: 0, width: 20, height: 10))
        field.leftViewMode = .always
        field.placeholder = "Месяц"
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()
    
    private lazy var dismissButton: UIBarButtonItem = {
        var button = UIBarButtonItem(
            image: UIImage(named: "dismiss"), style: .plain,
            target: self, action: #selector(self.dismissButtonTapped))
        button.tintColor = AppColors.textDarkColor.color()
        return button
    }()
    
    private lazy var doneButton: UIButton = {
        var button = UIButton(type: .system)
        button.layer.cornerRadius = 25
        button.setTitle("Готово", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .semibold)
        button.backgroundColor = AppColors.mainColor.color()
        button.adjustsImageWhenHighlighted = true
        button.addTarget(self, action: #selector(self.doneButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    //MARK: - View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .groupTableViewBackground
        self.addSubviews()
        self.makeConstraints()
    }
    
    //MARK: - Constraints
    
    private func makeConstraints() {
        self.titleLabel.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview().inset(20)
        }
        self.scrollView.snp.makeConstraints { (make) in
            make.top.equalTo(self.titleLabel.snp.bottom).offset(20)
            make.left.right.bottom.equalToSuperview()
            make.width.equalToSuperview()
        }
        self.mainView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(80)
            make.width.equalTo(self.view.frame.width - 40)
            //make.height.equalTo(700)
        }
        
        self.cardView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview().inset(20)
            make.height.equalTo(180)
        }
        self.cartCVCView.snp.makeConstraints { (make) in
            make.top.left.equalToSuperview().inset(20)
        }
        self.cartCVCLable.snp.makeConstraints { (make) in
            make.edges.equalToSuperview().inset(20)
        }
        self.cartNumberLable.snp.makeConstraints { (make) in
            make.right.equalToSuperview().inset(20)
            make.centerY.equalTo(self.cartCVCView.snp.centerY)
        }
        self.cartNameLable.snp.makeConstraints { (make) in
            make.left.bottom.equalToSuperview().inset(20)
        }
        self.cartDateLable.snp.makeConstraints { (make) in
            make.right.equalToSuperview().inset(20)
            make.centerY.equalTo(self.cartNameLable.snp.centerY)
        }
        
        self.cartNumberField.snp.makeConstraints { (make) in
            make.top.equalTo(self.cardView.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(60)
        }
        self.cartNameField.snp.makeConstraints { (make) in
            make.top.equalTo(self.cartNumberField.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(60)
        }
        self.cartCVCField.snp.makeConstraints { (make) in
            make.top.equalTo(self.cartNameField.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(60)
        }
        self.cartDateYearField.snp.makeConstraints { (make) in
            make.top.equalTo(self.cartCVCField.snp.bottom).offset(20)
            make.left.equalToSuperview().inset(20)
            make.size.equalTo(CGSize(width: 150, height: 60))
            
        }
        self.cartDateMonthField.snp.makeConstraints { (make) in
            make.top.equalTo(self.cartCVCField.snp.bottom).offset(20)
            make.right.bottom.equalToSuperview().inset(20)
            make.size.equalTo(CGSize(width: 150, height: 60))
        }
        
        self.doneButton.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview().inset(20)
            make.height.equalTo(50)
        }
    }
    
    //MARK: - Setters
    
    private func addSubviews() {
        self.view.addSubview(self.titleLabel)
        self.view.addSubview(self.scrollView)
        self.view.addSubview(self.doneButton)
        self.scrollView.addSubview(self.mainView)
        self.mainView.addSubview(self.cardView)
        self.cardView.addSubview(self.cartCVCView)
        self.cartCVCView.addSubview(self.cartCVCLable)
        self.cardView.addSubview(self.cartNameLable)
        self.cardView.addSubview(self.cartNumberLable)
        self.cardView.addSubview(self.cartDateLable)
        
        self.mainView.addSubview(self.cartNumberField)
        self.mainView.addSubview(self.cartNameField)
        self.mainView.addSubview(self.cartCVCField)
        self.mainView.addSubview(self.cartDateYearField)
        self.mainView.addSubview(self.cartDateMonthField)
    }
    
    //MARK: - Actions
    
    @objc private func dismissButtonTapped() {
        self.dismissHandler?()
    }
    
    @objc private func doneButtonTapped(_ sender: UIButton) {
        print("done add cart")
    }
    
}
