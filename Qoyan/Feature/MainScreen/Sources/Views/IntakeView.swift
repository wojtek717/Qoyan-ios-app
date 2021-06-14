//
//  IntakeView.swift
//  MainScreen
//
//  Created by Wojciech Konury on 04/06/2021.
//

import SwiftUI
import Vendors
import ComposableArchitecture
import QoyanUI
import Combine

public struct IntakeState: Equatable {
    var intakeGoal: Int = 2000
    var intakeCurrent: Int = 0
    
    var intakePercentage: CGFloat {
        if intakeCurrent == 0 || intakeGoal == 0 {
            return 0
        }
        
        return CGFloat(intakeCurrent)/CGFloat(intakeGoal)
    }
    
    var intakePercentageString: String {
        let percentage =  intakePercentage * 100
        return String(format: "%.0f", percentage) + "%"
    }
    
    var intakeAmount: String {
        return String(intakeGoal)
    }
    
    var intakeLeft: String {
        if intakeCurrent > intakeGoal { return "0" }
        
        return "- \(String(intakeGoal - intakeCurrent))"
    }
    
    var gradientRotation: Angle {
        if intakePercentage <= 1 {
            return Angle.degrees(-90)
        } else {
            return Angle.degrees(-90.0 + 360.0 * Double(intakePercentage))
        }
    }
}

public enum IntakeAction: Equatable { }

public struct IntakeEnvironment {
    public init() { }
}

public let intakeReducer = Reducer<IntakeState, IntakeAction, IntakeEnvironment>.combine(
    .init { state, action, _ in
        switch action { }
    })

public struct IntakeView: View {
    let store: Store<IntakeState, IntakeAction>
    
    @State private var keyboardHeight: CGFloat = 1
    
    var colors: [Color] = [
        Color(QoyanUI.QoyanUIAsset.purpleLight.color),
        Color(QoyanUI.QoyanUIAsset.purpleLightDarker.color),
    ]
    
    public var body: some View {
        WithViewStore(self.store) { viewStore in
            ZStack {
                Circle()
                    .stroke(
                        Color(QoyanUI.QoyanUIAsset.purpleBackground.color),
                        lineWidth: 20)
                    .frame(
                        width: 250 * keyboardHeight,
                        height: 250 * keyboardHeight,
                        alignment: .center)
                    .animation(.easeIn)
                Circle()
                    .trim(
                        from: 0,
                        to: viewStore.state.intakePercentage)
                    .stroke(
                        AngularGradient(
                            gradient: Gradient(colors: colors),
                            center: .center,
                            startAngle: .degrees(0),
                            endAngle: .degrees(360)
                        ),
                        style: StrokeStyle(
                            lineWidth: 20,
                            lineCap: .round))
                    .rotationEffect(
                        viewStore.state.gradientRotation)
                    .frame(
                        width: 250 * keyboardHeight,
                        height: 250 * keyboardHeight,
                        alignment: .center)
                    .animation(.easeIn)
                Circle()
                    .frame(
                        width: 20,
                        height: 20)
                    .foregroundColor(Color(QoyanUI.QoyanUIAsset.purpleLight.color))
                    .offset(y: -125.0 * keyboardHeight)
                    .opacity(viewStore.intakePercentage > 1 ? 0 : 1)
                    .animation(.easeIn)
                Circle()
                    .frame(
                        width: 20,
                        height: 20)
                    .foregroundColor(
                        viewStore.state.intakePercentage > 0.95
                            ? Color(QoyanUI.QoyanUIAsset.purpleLightDarker.color)
                            : Color(QoyanUI.QoyanUIAsset.purpleLightDarker.color).opacity(0))
                    .offset(y: -125 * keyboardHeight)
                    .rotationEffect(
                        Angle.degrees(360 * Double(viewStore.state.intakePercentage)))
                    .animation(.easeIn)
                
                VStack {
                    Text(viewStore.intakePercentageString)
                        .font(Font(QoyanUI.QoyanUIFontFamily.RoundedMplus1c.medium.font(size: 45.0)))
                        .foregroundColor(Color(QoyanUI.QoyanUIAsset.purpleDark.color))
                    Text(viewStore.intakeAmount + " ml")
                        .font(Font(QoyanUI.QoyanUIFontFamily.RoundedMplus1c.medium.font(size: 25.0)))
                        .foregroundColor(Color(QoyanUI.QoyanUIAsset.purpleDark.color))
                    Text(viewStore.intakeLeft + " ml")
                        .font(Font(QoyanUI.QoyanUIFontFamily.RoundedMplus1c.regular.font(size: 17.0)))
                        .foregroundColor(Color(QoyanUI.QoyanUIAsset.purpleGray.color))
                }
            }
            .onReceive(Publishers.keyboardHeight, perform: {
                self.keyboardHeight = $0
            })
        }
        
    }
}

struct IntakeView_Previews: PreviewProvider {
    static var previews: some View {
        IntakeView(store: .init(initialState: IntakeState(), reducer: intakeReducer, environment: IntakeEnvironment()))
    }
}

