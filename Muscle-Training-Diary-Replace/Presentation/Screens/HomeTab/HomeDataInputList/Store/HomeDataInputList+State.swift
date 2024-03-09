//
//  HomeDataInputList+State.swift
//  Muscle-Training-Diary-Replace
//
//  Created by 東　秀斗 on 2024/02/25.
//

import SwiftUI
import Foundation
import ComposableArchitecture

extension HomeDataInputListStore {
    @ObservableState
    struct State: Equatable {
        var homeDataInputStateList: IdentifiedArrayOf<HomeDataInputStore.State> = [.init(base: .init())]
        var view: ViewState {
            .init(isKeyboardOpen: homeDataInputStateList.contains(where: { $0.focusedField != nil }))
        }
        @Presents var alert: AlertState<Action.Alert>?
        var showSuccessView: Bool = false
        var successImage: Image {
            let images = [
                Asset.kurimanjuHa.swiftUIImage,
                Asset.kurimanjuSanba.swiftUIImage,
                Asset.kurimanjuShisa.swiftUIImage,
                Asset.muscleHachiware.swiftUIImage,
                Asset.muscleUsagi.swiftUIImage,
                Asset.shisa.swiftUIImage,
                Asset.usagiMatanozoki.swiftUIImage,
                Asset.hachiwareLabel.swiftUIImage,
                Asset.hachiwareShobon.swiftUIImage,
                Asset.chiikawa.swiftUIImage,
                Asset.chiikawaPicture.swiftUIImage,
                Asset.chiikawaWithChiikabu.swiftUIImage,
                Asset.chiiawaUsagiPicture.swiftUIImage
            ]
            return images.randomElement()!
        }
    }
}

extension HomeDataInputListStore {
    struct ViewState: Equatable {
        var isKeyboardOpen: Bool
    }
}
