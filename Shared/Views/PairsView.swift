//
//  PairsView.swift
//  TradingDemo (iOS)
//
//  Created by Jeffrey Sun on 9/13/22.
//

import SwiftUI

struct PairsView: View {
    @EnvironmentObject var modelData: ModelData
    @ObservedObject var networkingManager = PairsNetworkManager()
    var showingPairs: Binding<Bool>

    var body: some View {
        List(networkingManager.results, id:\.symbol) { pair in
            HStack {
                Text(pair.symbol)
                Spacer()
                if pair.symbol == modelData.tradeSelection.pair {
                    Image(systemName: "checkmark")
                        .foregroundColor(.secondary)
                }
            }
            .contentShape(Rectangle())
                .onTapGesture {
                    modelData.tradeSelection.pair = pair.symbol
                    showingPairs.wrappedValue = false
                }
        }
    }
}
  

struct PairsView_Previews: PreviewProvider {
    static var previews: some View {
        PairsView(showingPairs: Binding.constant(true))
    }
}
