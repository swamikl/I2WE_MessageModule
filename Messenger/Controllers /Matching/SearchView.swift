//
//  SearchView.swift
//  I2WE
//
//  Created by Jaden Kim on 11/2/20.
//

import SwiftUI

struct SearchView: View {

    @ObservedObject var store = UsersStore()
    @ObservedObject var zodiac = ZodiacStore()
    @ObservedObject var pronouns = PronounStore()
    @ObservedObject var pref = PrefStore()
    @ObservedObject var mbti = MBTIStore()
    
    @State var mbtiSelector: [Int] = []
    @State var prefSelector: [Int] = []
    @State var zodiacSelector: [Int] = []
    
    @State var width: CGFloat = 0
    @State var width1: CGFloat = 20
    let circleSize: CGFloat = 12
    var totalWidth = UIScreen.main.bounds.width - 100
    
    
    var body: some View {
        ScrollView(/*@START_MENU_TOKEN@*/.vertical/*@END_MENU_TOKEN@*/, showsIndicators: false) {
            GeometryReader { geometry in
                // let lo = Int((width / totalWidth) * (70-18)) + 18
                // let hi = Int((width1 / totalWidth) * (70-18)) + 18
                // let hiDisplay: String = (hi == 70) ? "70+" : String(hi)
                // let check: String = "✅"
                
                VStack {
                    VStack {
                        Text("Age")
                            .font(.title)
                            .fontWeight(.bold)
                            .frame(maxWidth: geometry.size.width - 40, alignment: .leading)
                        VStack(alignment: .leading) {
                            // Text("\(lo) - \(hiDisplay)")
                                Text("Text #1 for lo and highDisplay")
                                .font(.caption)
                                .foregroundColor(Color.white)
                                .padding(5)
                                .background(Color(#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)))
                                .cornerRadius(20)
                            ZStack(alignment: .leading) {
                                Rectangle()
                                    .fill(Color.black.opacity(0.2))
                                    .frame(height:3)
                                Rectangle()
                                    .fill(Color.black)
                                    .frame(width: self.width1 - self.width, height: 3)
                                    .offset(x: self.width + self.circleSize)
                                HStack {
                                    Circle()
                                        .fill(Color.black)
                                        .frame(width: self.circleSize, height: self.circleSize)
                                        .offset(x: self.width)
                                        .gesture(
                                            DragGesture()
                                                .onChanged {value in
                                                    if (value.location.x >= 0 && value.location.x <= self.width1) {
                                                        self.width = value.location.x
                                                    }
                                                }
                                        )
                                    Circle()
                                        .fill(Color.black)
                                        .frame(width: self.circleSize, height: self.circleSize)
                                        .offset(x: self.width1 - self.circleSize)
                                        .gesture(
                                            DragGesture()
                                                .onChanged {value in
                                                    if (value.location.x <= self.totalWidth && value.location.x >= self.width) {
                                                        self.width1 = value.location.x
                                                    }
                                                }
                                        )
                                }
                            }
                        }
                    }
                    .padding(20)
                    .border(/*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/, width: 3)
                    .padding(.top, 20)
                    .padding(.horizontal, 20)
                    .padding(.bottom, 10)
                    
                    VStack {
                        Text("Gender")
                            .font(.title)
                            .fontWeight(.bold)
                            .frame(maxWidth: geometry.size.width - 40, alignment: .leading)
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack {
                                ForEach(0..<self.pref.pref.count) { p in
                                    Button(action: {
                                        self.prefSelector.contains(p) ? self.prefSelector.removeAll(where: { $0 == p }) : self.prefSelector.append(p)
                                    }) {
                                        Text("\(self.pref.pref[p]!)")
                                        .font(.caption)
                                        .foregroundColor(Color.white)
                                        .padding(5)
                                            .background((self.prefSelector.contains(p)) ? Color(#colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)) : Color(#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)))
                                        .cornerRadius(20)
                                    }
                                }
                            }
                        }
                    }
                    .padding(20)
                    .border(/*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/, width: 3)
                    .padding(.horizontal, 20)
                    .padding(.bottom, 10)
                    
                    VStack(alignment: .leading) {
                        Text("Location")
                            .font(.title)
                            .fontWeight(.bold)
                            .frame(maxWidth: geometry.size.width - 40, alignment: .leading)
                        Text("Search for a location...")
                            .font(.caption)
                            .frame(maxWidth: geometry.size.width - 40, alignment: .leading)
                            .padding(10)
                            .border(/*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/, width: 1.5)
                    }
                    .padding(20)
                    .border(/*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/, width: 3)
                    .padding(.horizontal, 20)
                    .padding(.bottom, 10)
                    
                    VStack {
                        Text("MBTI")
                            .font(.title)
                            .fontWeight(.bold)
                            .frame(maxWidth: geometry.size.width - 40, alignment: .leading)
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack {
                                ForEach(0..<self.mbti.mbti.count) { p in
                                    Button(action: {
                                        self.mbtiSelector.contains(p) ? self.mbtiSelector.removeAll(where: { $0 == p }) : self.mbtiSelector.append(p)
                                    }) {
                                        Text("\(self.mbti.mbti[p]!)")
                                        .font(.caption)
                                        .foregroundColor(Color.white)
                                        .padding(5)
                                            .background((self.mbtiSelector.contains(p)) ? Color(#colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)) : Color(#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)))
                                        .cornerRadius(20)
                                    }
                                }
                            }
                        }
                    }
                    .padding(20)
                    .border(/*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/, width: 3)
                    .padding(.horizontal, 20)
                    .padding(.bottom, 10)
                    
                    VStack {
                        Text("Zodiac")
                            .font(.title)
                            .fontWeight(.bold)
                            .frame(maxWidth: geometry.size.width - 40, alignment: .leading)
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack {
                                ForEach(0..<self.zodiac.zodiac.count) { p in
                                    Button(action: {
                                    self.zodiacSelector.contains(p) ? self.zodiacSelector.removeAll(where: { $0 == p }) : self.zodiacSelector.append(p)
                                    }) {
                                        // Text("\(self.zodiacSelector.contains(p) ? check : zodiac.zodiac[p]!)")
                                        Text("✅")
                                        .font(.caption)
                                    }
                                }
                            }
                        }
                    }
                    .padding(20)
                    .border(/*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/, width: 3)
                    .padding(.horizontal, 20)
                    .padding(.bottom, 10)
                }
            }
        }
    }
}


