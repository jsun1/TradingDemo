//
//  TradeView.swift
//  TradingDemo
//
//  Created by Jeffrey Sun on 9/11/22.
//

import SwiftUI
import Charts

struct TradeView: View {
    @EnvironmentObject var modelData: ModelData
//    @Binding var tradeSelection: TradeSelection
    
    var body: some View {
        NavigationView {
            VStack {
                Picker("Time", selection: $modelData.tradeSelection.time) {
                    ForEach(TradeSelection.Time.allCases) { time in
                        Text(time.rawValue).tag(time)
                    }
                }
                .padding()
                .pickerStyle(.segmented)

//                Text("Hello, World!")
//                CandleStickChartView()
                CandleView()
                    .environmentObject(modelData)
                    .padding([.leading, .trailing])
                
                List {
                    HStack {
                        Picker("Type", selection: $modelData.tradeSelection.type) {
                            ForEach(TradeSelection.TradeType.allCases) { time in
                                Text(time.rawValue).tag(time)
                            }
                        }
                        .pickerStyle(.menu)
                        Spacer()
                        Picker("Side", selection: $modelData.tradeSelection.side) {
                            ForEach(TradeSelection.Side.allCases) { time in
                                Text(time.rawValue).tag(time)
                            }
                        }
                        .pickerStyle(.segmented)
                        .frame(width: 140)
                    }
                    HStack {
                        Text("Price").bold()
                        Divider()
                        TextField("Price", text: $modelData.tradeSelection.price)
                        Spacer()
                        Text("USD").foregroundColor(.secondary)
                    }
                    HStack {
                        Text("Amount").bold()
                        Divider()
                        TextField("0", text: $modelData.tradeSelection.amount)
                        Spacer()
                        Text("USD").foregroundColor(.secondary)
                    }
                    Button(action: {
                        // Whatever button action you want.
                    }, label: {
                        Text("Place order")
                            .frame(maxWidth: .infinity)
                    })
                    .buttonStyle(.borderedProminent)
                }

                Spacer()
            }
            .navigationTitle("Trade")
        }
    }
}

struct TradeView_Previews: PreviewProvider {
    static var previews: some View {
        TradeView()
            .environmentObject(ModelData())
    }
}
