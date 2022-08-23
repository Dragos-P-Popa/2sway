//
//  CircularProgressView.swift
//  2Sway
//
//  Created by Dragos Popa on 04/08/2022.
//

import SwiftUI

struct CircularProgressView: View {
    let progress: Double
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(
                    Color.blue.opacity(0.5),
                    lineWidth: 30
                )
            Circle()
                .trim(from: 0, to: progress)
                .stroke(
                    Color.blue,
                    style: StrokeStyle(
                        lineWidth: 30,
                        lineCap: .round
                    )
                )
                .frame(width: 300, height: 300)
                .rotationEffect(.degrees(-90))
                .animation(.easeOut, value: progress)

        }
    }
}
