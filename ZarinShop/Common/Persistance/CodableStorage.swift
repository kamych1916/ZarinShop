//
//  CodableStorage.swift
//  CurrencyApp
//
//  Created by Murad Ibrohimov on 11/9/20.
//

import Foundation

//save // try? CodableStorage.shared.save(models, for: url.rawValue)
//get // let fethchedModels: [BankRatesModel] = try CodableStorage.shared.fetch(for: url.rawValue)

typealias Handler<T> = (Result<T, Error>) -> Void
typealias Storage = ReadableStorage & WritableStorage

protocol ReadableStorage {
    func fetchValue(for key: String) throws -> Data
    func fetchValue(for key: String, handler: @escaping Handler<Data>)
}

protocol WritableStorage {
    func save(value: Data, for key: String) throws
    func save(value: Data, for key: String, handler: @escaping Handler<Data>)
}

class CodableStorage {
    
    static let shared = CodableStorage()
    
    private let storage: DiskStorage
    private let decoder: JSONDecoder
    private let encoder: JSONEncoder

    private init() {
        let path = URL(fileURLWithPath: NSTemporaryDirectory())
        let disk = DiskStorage(path: path)
        self.storage = disk
        self.decoder = .init()
        self.encoder = .init()
    }

    func fetch<T: Decodable>(for key: String) throws -> T {
        let data = try storage.fetchValue(for: key)
        return try decoder.decode(T.self, from: data)
    }

    func save<T: Encodable>(_ value: T, for key: String) throws {
        let data = try encoder.encode(value)
        try storage.save(value: data, for: key)
    }
}
