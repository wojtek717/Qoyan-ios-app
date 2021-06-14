//
//  Core.swift
//  Qoyan-iOS
//
//  Created by Wojciech Konury on 02/06/2021.
//

import SwiftUI
import Vendors
import ComposableArchitecture
import QoyanUI

public struct RootState: Equatable {
    public init() {}
    
    var intakeState = IntakeState()
    var amountPickerState = AmountPickerState()
}

public enum RootAction: Equatable {
    case intakeAction(IntakeAction)
    case amountPickerAction(AmountPickerAction)
    
    case onAppear
}

public struct RootEnvironment {
    public init() { }
}

public let rootReducer = Reducer<RootState, RootAction, RootEnvironment>.combine(
    .init { state, action, _ in
        switch action {
        case .onAppear:
            state = .init()
            return .none
        case .amountPickerAction(.addButtonTapped):
            state.intakeState.intakeCurrent += Int(state.amountPickerState.intakeValue)
            return .none
        default:
            return .none
        }
    },
    intakeReducer.pullback(
        state: \.intakeState,
        action: /RootAction.intakeAction,
        environment: { _ in .init() }),
    
    amountPickerReducer.pullback(
        state: \.amountPickerState,
        action: /RootAction.amountPickerAction,
        environment: { _ in .init() })
).debug()

