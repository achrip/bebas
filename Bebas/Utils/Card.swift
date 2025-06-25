//
//  Card.swift
//  Bebas
//
//  Created by Adya Muhammad Prawira on 18/06/25.
//

import SwiftUI

struct Card: Identifiable, Equatable {
    let id = UUID()
    let value: String
    let color: Color
    let rotation: Double
    var image: String
    var isFlipped: Bool = false

    static func == (lhs: Card, rhs: Card) -> Bool {
        lhs.id == rhs.id
    }
}

struct CardView: View {
    @Binding var card: Card
    @State private var rotationDegrees: Double = 0

    var body: some View {
        ZStack {
            frontView
                .opacity(rotationDegrees.truncatingRemainder(dividingBy: 360) < 90 || rotationDegrees.truncatingRemainder(dividingBy: 360) > 270 ? 1 : 0)

            backView
                .opacity(rotationDegrees.truncatingRemainder(dividingBy: 360) >= 90 && rotationDegrees.truncatingRemainder(dividingBy: 360) <= 270 ? 1 : 0)
                .rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))
        }
        .frame(width: 250, height: 350)
        .rotation3DEffect(.degrees(rotationDegrees), axis: (x: 0, y: 1, z: 0))
        .onTapGesture {
            withAnimation(.easeInOut(duration: 0.6)) {
                rotationDegrees += 180
                card.isFlipped.toggle()
            }
        }
    }

    var frontView: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(card.color)
                .shadow(radius: 10)

            Text(card.value)
                .font(.system(size: 100, weight: .bold))
                .foregroundColor(.white)
        }
    }

    var backView: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(card.color.opacity(0.85))
                .shadow(radius: 10)
            
            Image(card.image)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 150, height: 250)
        }
    }
}
