//
//  RoundedTextStyle.swift
//  Muscle-Training-Diary-Replace
//
//  Created by 東　秀斗 on 2024/02/26.
//

import Foundation
import SwiftUI

struct RoundedTextStyle: ViewModifier {
    let isEmpty: Bool
    func body(content: Content) -> some View {
        content
            .padding(5)
            .textFieldStyle(.plain)
            .background(
                RoundedRectangle(cornerRadius: 5)
                    .stroke(Color.black, lineWidth: 1)
            )
            .background(
                Color.white
                    .cornerRadius(5)
            )
    }
}

extension View {
    func roundedTextStyle(isEmpty: Bool) -> some View {
        self.modifier(RoundedTextStyle(isEmpty: isEmpty))
    }
}
