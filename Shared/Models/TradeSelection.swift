//
//  TradeSelection.swift
//  TradingDemo
//
//  Created by Jeffrey Sun on 9/11/22.
//

import Foundation

struct TradeSelection {
    var time = Time.oneMinute
    var side = Side.buy
    var type = TradeType.limit
    var price: String = ""
    var amount: String = ""

    static let `default` = TradeSelection()

    enum Time: String, CaseIterable, Identifiable {
        case oneMinute = "1m"
        case fifteenMinute = "15m"
        case oneHour = "1h"
        case oneDay = "1d"

        var id: String { rawValue }
    }
    
    enum Side: String, CaseIterable, Identifiable {
        case buy = "Buy"
        case sell = "Sell"
        var id: String { rawValue }
    }
    
    enum TradeType: String, CaseIterable, Identifiable {
        case limit = "Limit order"
        case market = "Market order"
        case stopMarket = "Stop market"
        case stopLimit = "Stop limit"
        case trailingStop = "Trailing stop"
        case takeProfit = "Take profit"
        case takeProfitLimit = "Take profit limit"
        case twap = "TWAP"

        var id: String { rawValue }
    }
}
