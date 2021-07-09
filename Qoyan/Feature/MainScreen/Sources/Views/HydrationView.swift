//
//  HydrationView.swift
//  MainScreen
//
//  Created by Wojciech Konury on 14/06/2021.
//

import SwiftUI
import Vendors
import ComposableArchitecture
import QoyanUI

public struct HydrationState: Equatable {
    var intakeState = IntakeState()
    var ammountState = AmountPickerState()
}

public enum HydrationAction: Equatable {
    case intakeAction(IntakeAction)
    case ammountAction(AmountPickerAction)
}

public struct HydrationEnvironment {
    public init() { }
}

public let hydrationReducer = Reducer<HydrationState, HydrationAction, HydrationEnvironment>.combine(
    .init { state, action, _ in
        switch action {
        case .ammountAction(.addButtonTapped):
            state.intakeState.intakeCurrent += Int(state.ammountState.intakeValue)
            return .none
            
        default:
            return .none
        }
    },
    intakeReducer.pullback(
        state: \HydrationState.intakeState,
        action: /HydrationAction.intakeAction,
        environment: { _ in IntakeEnvironment() }
    ),
    amountPickerReducer.pullback(
        state: \HydrationState.ammountState,
        action: /HydrationAction.ammountAction,
        environment: { _ in AmountPickerEnvironment() }
    )
)

public struct HydrationView: View {
    let store: Store<HydrationState, HydrationAction>
    
    init(store: Store<HydrationState, HydrationAction>) {
        self.store = store
    }
    
    public var body: some View {
        WithViewStore(self.store) { viewStore in
            VStack {
                Text("Current Hydration")
                    .font(Font(QoyanUI.QoyanUIFontFamily.RoundedMplus1c.regular.font(size: 25.0)))
                    .foregroundColor(Color(QoyanUI.QoyanUIAsset.purpleDark.color))
                    .padding(.bottom, 25)
                
                IntakeView(store: self.store.scope(
                            state: \.intakeState,
                            action: HydrationAction.intakeAction))
                Spacer()
                
                AmountPickerView(store: self.store.scope(
                                    state: \.ammountState,
                                    action: HydrationAction.ammountAction))
                    .padding(.horizontal, 35)
                
            }
            .padding()
        }
    }
}

struct HydrationView_Previews: PreviewProvider {
    static var previews: some View {
        HydrationView(store: .init(
                    initialState: HydrationState(),
                    reducer: hydrationReducer,
                    environment: HydrationEnvironment()))
    }
}
