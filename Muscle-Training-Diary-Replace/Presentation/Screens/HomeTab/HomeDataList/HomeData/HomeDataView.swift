//
//  HomeDataView.swift
//  Muscle-Training-Diary-Replace
//
//  Created by 東　秀斗 on 2024/02/27.
//

import SwiftUI
import ComposableArchitecture

struct HomeDataView: View {
    var training: Training

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text("\(training.date.fullDate)")
            Text(training.name)
            HStack {
                Text(training.weightLabel)
                Text(training.countLabel)
            }
        }
        .bold()
        .foregroundColor(.black)
        .font(.custom("HanazomeFont", size: 20))
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(
            Color.white
                .opacity(0.6)
        )
        .background(
            Asset.muscleHachiware.swiftUIImage
                .resizable()
                .scaledToFit()
                .frame(maxWidth: .infinity, alignment: .trailing)
        )
        .cornerRadius(15)
        .clipped()
        .padding(.horizontal)
    }
}

#Preview {
    HomeDataView(training: .fake)
    .frame(maxHeight: .infinity)
    .background(Asset.lightGreen.swiftUIColor)
}
