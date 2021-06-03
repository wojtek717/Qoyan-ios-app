//
//  Core.swift
//  Qoyan-iOS
//
//  Created by Wojciech Konury on 02/06/2021.
//

import SwiftUI
import Vendors
import ComposableArchitecture

public struct RootState: Equatable {
    public init(){}
}

public enum RootAction: Equatable {
    case onAppear
}

public struct RootEnvironment {
    public init(){}
}

public let rootReducer = Reducer<RootState, RootAction, RootEnvironment>.combine(
    .init { state, action, _ in
        switch action {
        case .onAppear:
          state = .init()
          return .none
        }
    })

