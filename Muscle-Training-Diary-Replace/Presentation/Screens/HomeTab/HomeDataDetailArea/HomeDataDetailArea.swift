//
//  HomeDataDetailArea.swift
//  Muscle-Training-Diary-Replace
//
//  Created by 東　秀斗 on 2024/02/28.
//

import SwiftUI

struct HomeDataDetailArea: View {
    let trainingDetail: TrainingDetail

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(trainingDetail.name)
                .font(.custom("HanazomeFont", size: 17))
                .lineLimit(2)
            Text(trainingDetail.maxWeightLabel)
                .font(.custom("HanazomeFont", size: 15))
            Text(trainingDetail.previousWeightLabel)
                .font(.custom("HanazomeFont", size: 15))
        }
        .padding()
        .frame(width: 170, height: 115, alignment: .top)
        .background(
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.white, lineWidth: 2)
                Asset.usagiMatanozoki.swiftUIImage
                    .resizable()
                    .scaledToFit()
                    .frame(height: 75)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
                    .opacity(0.6)
            }
        )
        .foregroundColor(.black)
    }
}

#Preview {
    HomeDataDetailArea(trainingDetail: .init(name: "スミスマシンインクライン",
                                             maxWeight: 100.00,
                                             previousWeight: 100.00,
                                             unit: .kilogram))
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Asset.lightGreen.swiftUIColor)
}
