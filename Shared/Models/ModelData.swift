//
//  ModelData.swift
//  TradingDemo
//
//  Created by Jeffrey Sun on 9/11/22.
//

import Foundation

final class ModelData: ObservableObject {
    @Published var tradeSelection = TradeSelection.default
}
