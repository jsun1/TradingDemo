//
//  CandleView.swift
//  TradingDemo (iOS)
//
//  Created by Jeffrey Sun on 9/12/22.
//

import Charts
import SwiftUI
import UIKit

struct CandleView: UIViewRepresentable {
    let baseURL = "https://api.binance.us"
    let klinesPath = "/api/v3/klines"
//    var numberOfPages: Int
//    @Binding var currentPage: Int
    @EnvironmentObject var modelData: ModelData
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIView(context: Context) -> CandleStickChartView {
//        let control = UIPageControl()
//        control.numberOfPages = numberOfPages
//        control.addTarget(
//            context.coordinator,
//            action: #selector(Coordinator.updateCurrentPage(sender:)),
//            for: .valueChanged)
        let chartView = CandleStickChartView()
        chartView.leftAxis.enabled = false
        chartView.xAxis.enabled = false
//        chartView.
//        let dataSet = CandleChartDataSet(entries: [CandleChartDataEntry(x: 0, shadowH: 0.4, shadowL: 0, open: 0.1, close: 0.2)], label: nil)
//        chartView.data = CandleChartData(dataSets: [dataSet])
//        chartView.data = CandleChartData()

        return chartView
    }

    func updateUIView(_ uiView: CandleStickChartView, context: Context) {
//        uiView.currentPage = currentPage
        print("update ui view")
        let symbol = modelData.tradeSelection.pair
        let interval = modelData.tradeSelection.time.rawValue
        let limit = "50"
        let parameters = "symbol=\(symbol)&interval=\(interval)&limit=\(limit)"
        
        getApiCallAsync(api: klinesPath, parameters: parameters) { received in
            DispatchQueue.main.async {
                if let candles = received as? [[Any]] {
                    let entries = candles.map { candle -> CandleChartDataEntry in
                        let time = candle[0] as! Double
                        let open = Double(candle[1] as! String)!
                        let high = Double(candle[2] as! String)!
                        let low = Double(candle[3] as! String)!
                        let close = Double(candle[4] as! String)!
                        let entry = CandleChartDataEntry(x: time, shadowH: high, shadowL: low, open: open, close: close)
//                        entry.col
                        return entry
                    }
    //                for candle in candles {
    //                    let entry = CandleChartDataEntry(x: candle[0], shadowH: candle[3], shadowL: candle[2], open: candle[1], close: candle[4])
    //                }
                    let dataset = CandleChartDataSet(entries: entries, label: symbol)
                    dataset.increasingColor = .red
                    dataset.increasingFilled = true
                    dataset.decreasingColor = .green
                    dataset.decreasingFilled = true
                    dataset.shadowColorSameAsCandle = true
//                    dataset.barSpace = 0
                    dataset.showCandleBar = false
                    dataset.valueTextColor = .clear
//                    datas
                    uiView.data = CandleChartData(dataSet: dataset)
                } else {
                    uiView.data = nil
                }
            }
        }
    }
    
    func getApiCallAsync(api: String, parameters: String, completion: @escaping ([Any]?) -> Void) {
        let url = URL(string: baseURL + api + "?" + parameters)
        guard let requestUrl = url else { fatalError() }
        // Prepare URL Request Object
        var request = URLRequest(url: requestUrl)
        request.httpMethod = "GET"
        // Perform HTTP Request
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            var received: [Any]? = nil
            if let error = error {
                print(error.localizedDescription, String(describing: data))
            } else if let data = data {
                do {
                    received = try JSONSerialization.jsonObject(with: data) as? [Any]
                } catch {
                    print(error.localizedDescription)
                }
            }
            completion(received)
        }
        task.resume()
    }
    
    class Coordinator: NSObject {
        var candleView: CandleView
        
        init(_ candleView: CandleView) {
            self.candleView = candleView
        }
        
//        @objc
//        func updateCurrentPage(sender: UIPageControl) {
//            control.currentPage = sender.currentPage
//        }
    }
}
