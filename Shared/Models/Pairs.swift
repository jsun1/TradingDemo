//
//  Pairs.swift
//  TradingDemo (iOS)
//
//  Created by Jeffrey Sun on 9/13/22.
//

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
    
    init() {
        guard let url = URL(string: "https://api.binance.us/api/v3/exchangeInfo") else { return }
        
        URLSession.shared.dataTask(with: url) { (data, _, _) in
            guard let data = data else { return }
            
            let pairsInfo = try! JSONDecoder().decode(PairsInfo.self, from: data)
            
            DispatchQueue.main.async {
                self.results = pairsInfo.symbols
            }
        }.resume()
    }
}


