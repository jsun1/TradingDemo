//
//  Pairs.swift
//  TradingDemo (iOS)
//
//  Created by Jeffrey Sun on 9/13/22.
//

import Combine
import Foundation

struct PairsInfo: Decodable {
    var symbols: [Pair]
}

struct Pair: Decodable {
    var symbol: String
    var status: String
}

class PairsNetworkManager: ObservableObject {
    
    @Published var results = [Pair]()
    var cancellable: AnyCancellable? = nil
    
    init() {
        guard let url = URL(string: "https://api.binance.us/api/v3/exchangeInfo") else { return }
        
        cancellable = URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: PairsInfo.self, decoder: JSONDecoder())
            .map { $0.symbols }
            .replaceError(with: [])
            .eraseToAnyPublisher()
            .assign(to: \.results, on: self)
    }
}


