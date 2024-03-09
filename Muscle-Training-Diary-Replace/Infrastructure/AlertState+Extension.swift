//
//  AlertState+Extension.swift
//  Muscle-Training-Diary-Replace
//
//  Created by 東　秀斗 on 2024/02/28.
//

import Foundation
import ComposableArchitecture

extension AlertState {
    static func OkAndCancel(
        okLabel: String,
        cancelLabel: String,
        message: String,
        okAction: @Sendable () -> Action
    ) -> Self {
        AlertState {
            TextState("確認")
        } actions: {
            ButtonState(role: .cancel) {
                TextState(cancelLabel)
            }
            ButtonState(role:.destructive, action: okAction()) {
                TextState(okLabel)
            }
        } message: {
            TextState(message)
        }
    }
}
