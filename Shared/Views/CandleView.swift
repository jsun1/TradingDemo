//
//  CandleView.swift
//  TradingDemo (iOS)
//
//  Created by Jeffrey Sun on 9/12/22.
//

import Charts
import Combine
import SwiftUI
import UIKit

struct CandleView: UIViewRepresentable {
    let baseURL = "https://api.binance.us"
    let klinesPath = "/api/v3/klines"
    @EnvironmentObject var modelData: ModelData
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIView(context: Context) -> CandleStickChartView {
        let chartView = CandleStickChartView()
        chartView.leftAxis.enabled = false
        chartView.xAxis.enabled = false

        return chartView
    }

    func updateUIView(_ uiView: CandleStickChartView, context: Context) {
        print("update ui view")
        let symbol = modelData.tradeSelection.pair
        let interval = modelData.tradeSelection.time.rawValue
        let limit = "50"
        let parameters = "symbol=\(symbol)&interval=\(interval)&limit=\(limit)"
        
        context.coordinator.cancellable?.cancel()
        let publisher = getApiCallPublisher(api: klinesPath, parameters: parameters)
        let cancellable = publisher.sink(receiveValue: { received in
            DispatchQueue.main.async {
                if let candles = received as? [[Any]] {
                    let entries = candles.map { candle -> CandleChartDataEntry in
                        let time = candle[0] as! Double
                        let open = Double(candle[1] as! String)!
                        let high = Double(candle[2] as! String)!
                        let low = Double(candle[3] as! String)!
                        let close = Double(candle[4] as! String)!
                        let entry = CandleChartDataEntry(x: time, shadowH: high, shadowL: low, open: open, close: close)
                        return entry
                    }
                    let dataset = CandleChartDataSet(entries: entries, label: symbol)
                    dataset.increasingColor = .red
                    dataset.increasingFilled = true
                    dataset.decreasingColor = .green
                    dataset.decreasingFilled = true
                    dataset.shadowColorSameAsCandle = true
                    dataset.showCandleBar = false
                    dataset.valueTextColor = .clear
                    uiView.data = CandleChartData(dataSet: dataset)
                } else {
                    uiView.data = nil
                }
            }
        })
        context.coordinator.cancellable = cancellable
    }

    func getApiCallPublisher(api: String, parameters: String) -> AnyPublisher<[Any], Never> {
        let url = URL(string: baseURL + api + "?" + parameters)
        guard let requestUrl = url else { fatalError() }
        // Prepare URL Request Object
        var request = URLRequest(url: requestUrl)
        request.httpMethod = "GET"
        let publisher = URLSession.shared.dataTaskPublisher(for: request)
            .map { $0.data }
            .tryMap { try JSONSerialization.jsonObject(with: $0) as! [Any] }
            .replaceError(with: [])
            .eraseToAnyPublisher()
        return publisher
        
    }
    
    class Coordinator: NSObject {
        var candleView: CandleView
        var cancellable: AnyCancellable? = nil
        
        init(_ candleView: CandleView) {
            self.candleView = candleView
        }
    }
}
