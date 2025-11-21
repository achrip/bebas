//
//  CardAlphanumericView.swift
//  Bebas
//
//  Created by Adya Muhammad Prawira on 18/06/25.
//

import SwiftUI

struct AlphaNumericOptionView: View {
    @Binding var path: [Route]

    var body: some View {
        VStack {
            Spacer()
            Text("Mau belajar apa hari ini?")
                .font(.title)
                .bold()
            Spacer()
            HStack(spacing: 16) {
                Button(action: {
                    path.append(.alphaNumericAlphabet)
                }, label: {
                    ZStack {
                        Image("alfanumerik_huruf")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                        VStack {
                            Text("Huruf")
                                .font(.title2)
                                .foregroundColor(.white)
                                .bold()
                            Spacer()
                        }
                        .padding()
                    }
                })
                Button(action: {
                    path.append(.alphaNumericNumber)
                }, label: {
                    ZStack {
                        Image("alfanumerik_angka")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                        VStack {
                            Text("Angka")
                                .font(.title2)
                                .foregroundColor(.white)
                                .bold()
                            Spacer()
                        }
                        .padding()
                    }
                })
            }
            .frame(height: 240)
            Spacer()
            Spacer()
        }
        .padding()
        .navigationTitle("Kamus")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    path.removeAll()
                }) {
                    HStack {
                        Image(systemName: "chevron.left")
                        Text("Dashboard")
                    }
                }
            }
        }
    }
}

#Preview {
//    CardAlphaNumericView()
}
