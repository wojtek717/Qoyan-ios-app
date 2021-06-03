//
//  AmountPickerView.swift
//  MainScreen
//
//  Created by Wojciech Konury on 02/06/2021.
//

import SwiftUI
import Vendors
import ComposableArchitecture

public struct AmountPickerView: View {
    
    public var body: some View {
        HStack {
            Button(action: {}) {
                VStack {
                    Image(systemName: "arrow.up")
                    Text("50 ml")
                }
            }

            Spacer()
            
            Text("200 ml of water")
            
            Spacer()
            
            Button(action: {}) {
                VStack {
                    Image(systemName: "arrow.down")
                    Text("50 ml")
                }
            }
        }
    }
}

struct AmountPickerView_Previews: PreviewProvider {
    static var previews: some View {
        AmountPickerView()
    }
}

