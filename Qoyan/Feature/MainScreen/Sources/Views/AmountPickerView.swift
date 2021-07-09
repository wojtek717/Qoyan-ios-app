//
//  AmountPickerView.swift
//  MainScreen
//
//  Created by Wojciech Konury on 02/06/2021.
//

import SwiftUI
import Vendors
import ComposableArchitecture
import QoyanUI
import UIKit
import Combine

public struct AmountPickerState: Equatable {
    var intakeValue: Double = 0
    var textValue: String = ""
}

public enum AmountPickerAction: Equatable {
    case sliderValueChanged(Double)
    case textFieldValuChanged(String)
    case addButtonTapped
}

public struct AmountPickerEnvironment {
    public init() { }
}

public let amountPickerReducer = Reducer<AmountPickerState, AmountPickerAction, AmountPickerEnvironment>.combine(
    .init { state, action, _ in
        switch action {
        case let .sliderValueChanged(value):
            state.intakeValue = value
            state.textValue = String(format: "%.0f", value)
            return .none
        case .addButtonTapped:
            state.intakeValue = 0
            state.textValue = ""
            
            UIApplication.shared.endEditing()
            return .none
        case let .textFieldValuChanged(value):
            let value = value.count > 4 ? state.textValue : value
            var newValue = value.replacingOccurrences(of: ",", with: "")
            
            state.textValue = newValue
            state.intakeValue = Double(newValue) ?? 0.0
            return .none
        }
    }).debug()

public struct AmountPickerView: View {
    let store: Store<AmountPickerState, AmountPickerAction>
    
    @State private var isKeyboardExpanded: Bool = false
    
    public var body: some View {
        WithViewStore(self.store) { viewStore in
            VStack {
                TextField(
                    "0",
                    text: viewStore.binding(
                        get: \.textValue,
                        send: AmountPickerAction.textFieldValuChanged)
                )
                .disableAutocorrection(true)
                .font(Font(QoyanUI.QoyanUIFontFamily.RoundedMplus1c.medium.font(size: 35.0)))
                .foregroundColor(Color(QoyanUI.QoyanUIAsset.purpleDark.color))
                .multilineTextAlignment(.center)
                .lineLimit(1)
                .keyboardType(.decimalPad)
                
                Slider(
                    value: viewStore.binding(
                        get: \.intakeValue,
                        send: AmountPickerAction.sliderValueChanged
                    ),
                    in: 0.0...500.0,
                    step: 50.0)
                    .accentColor(Color(QoyanUI.QoyanUIAsset.purpleLight.color))
                    .opacity(isKeyboardExpanded ? 0 : 1)
                    
                
                Button("Drink") {
                    viewStore.send(.addButtonTapped)
                }
                .buttonStyle(NeumorphicButtonStyle(bgColor: Color(QoyanUIAsset.purpleLight.color)))
                .animation(.easeIn)
            }
            .onReceive(Publishers.isKeyboardExpanded, perform: { keyboardExpanded in
                withAnimation {
                    self.isKeyboardExpanded = keyboardExpanded
                }
            })
        }
    }
}

struct AmountPickerView_Previews: PreviewProvider {
    static var previews: some View {
        AmountPickerView(
            store: .init(
                initialState: AmountPickerState(),
                reducer: amountPickerReducer,
                environment: AmountPickerEnvironment()))
    }
}

struct NeumorphicButtonStyle: ButtonStyle {
    var bgColor: Color
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(15)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 20.0)
                    .fill(bgColor)
            )
            .font(Font(QoyanUI.QoyanUIFontFamily.RoundedMplus1c.medium.font(size: 20.0)))
            .foregroundColor(.white)
            .scaleEffect(configuration.isPressed ? 0.95: 1)
            .animation(.spring())
    }
    
}
