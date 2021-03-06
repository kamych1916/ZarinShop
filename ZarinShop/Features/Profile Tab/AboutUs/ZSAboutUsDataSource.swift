//
//  ZSAboutUsDataSource.swift
//  ZarinShop
//
//  Created by Murodjon Ibrohimov on 06.03.2021.
//  Copyright © 2021 Murad Ibrohimov. All rights reserved.
//

import UIKit

enum ZSAboutUsSection: CaseIterable {
    case info
    case socials
    
    var title: String {
        switch self {
        case .info: return "Основная информация"
        case .socials: return "Социальные сети"
        }
    }
    
    var items: [ZSAboutUsItem] {
        switch self {
        case .info: return [.address, .email, .phone, .phoneInfo]
        case .socials: return [.instagram, .facebook, .telegram]
        }
    }
    
}

enum ZSAboutUsItem {
    case address
    case email
    case phone
    case phoneInfo
    case instagram
    case facebook
    case telegram
    
    var title: String {
        switch self {
        case .address:   return "Ташкент, Яшнабадский р-н, 1 проезд Алимкент 36/1"
        case .email:     return "nfo@zarinshop.uz"
        case .phone:     return "+998 (72) 224-01-01"
        case .phoneInfo: return "Прием звонков: с 9:00 до 20:00 (Пн-Пт)"
        case .instagram: return "Instagram"
        case .facebook:  return "Facebook"
        case .telegram:  return "Telegram"
        }
    }
    
    var image: UIImage? {
        switch self {
        case .address:   return UIImage(named: "location")
        case .email:     return UIImage(named: "mail")
        case .phone:     return UIImage(named: "phone")
        case .phoneInfo: return UIImage(named: "clock")
        case .instagram: return UIImage(named: "instagram")
        case .facebook:  return UIImage(named: "facebook")
        case .telegram:  return UIImage(named: "telegram")
        }
    }
    
    var link: String? {
        switch self {
        case .address:   return nil
        case .email:     return "mailto:\(title)"
        case .phone:     return "tel://+998722240101"
        case .phoneInfo: return nil
        case .instagram: return "https://www.instagram.com/zarin_home_collection.uz/?igshid=b8ik4lwxxile"
        case .facebook:  return "https://www.facebook.com/zarin.home.96"
        case .telegram:  return "https://t.me/zarinhomecollection_1"
        }
    }
    
    var shortLink: String? {
        switch self {
        case .address, .email,
             .phone, .phoneInfo: return nil
        case .instagram: return "instagram://user?username=zarin_home_collection.uz"
        case .facebook:  return "fb://zarin.home.96"
        case .telegram:  return "tg://resolve?domain=zarinhomecollection_1"
        }
    }
    
}
