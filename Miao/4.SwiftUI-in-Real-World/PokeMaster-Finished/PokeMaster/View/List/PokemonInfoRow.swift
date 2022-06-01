//
//  PokemonInfoRow.swift
//  PokeMaster
//
//  Created by 王 巍 on 2019/08/29.
//  Copyright © 2019 OneV's Den. All rights reserved.
//

import SwiftUI

struct PokemonInfoRow: View {
    /*
     对于, 纯展示的 View 来说, ViewModel 没有信号处理相关的代码.
     就是根据 ViewModel 的数据, 进行 View 的配置而已.
     */
    let rowViewModel: PokemonViewModel
    let expanded: Bool
    
    var body: some View {
        VStack {
            HStack {
                Image("Pokemon-\(rowViewModel.id)")
                // Image 如果不写 resizable, 那么就是原始尺寸显示. 不受 frame 的控制.
                    .resizable()
                    .frame(width: 50, height: 50)
                    .border(Color.red, width: 1)
                    .aspectRatio(contentMode: .fit)
                    .shadow(radius: 4)
                Spacer()
                VStack(alignment: .trailing) {
                    Text(rowViewModel.name)
                        .font(.title)
                        .fontWeight(.black)
                        .foregroundColor(.white)
                    Text(rowViewModel.nameEN)
                        .font(.subheadline)
                        .foregroundColor(.white)
                }
            }
            .padding(.top, 12)
            
            Spacer()
            
            HStack(spacing: expanded ? 20 : -30) {
                Spacer()
                Button(action: {}) {
                    Image(systemName: "star")
                        .modifier(ToolButtonModifier())
                }
                Button(action: {}) {
                    Image(systemName: "chart.bar")
                        .modifier(ToolButtonModifier())
                }
                Button(action: {}) {
                    Image(systemName: "info.circle")
                        .modifier(ToolButtonModifier())
                }
            }
            .padding(.bottom, 12)
            .opacity(expanded ? 1.0 : 0.0)
            // 高度是跟随着 expanded 进行改变的.
            .frame(maxHeight: expanded ? .infinity : 0)
            .border(Color.yellow)
        }
        // 这是 VStack 的 Modifier 了, 也就是 Cell 整体的 Modifier.
        .frame(height: expanded ? 120 : 80)
        .padding(.leading, 23)
        .padding(.trailing, 15)
        .background(
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .stroke(rowViewModel.color, style: StrokeStyle(lineWidth: 4))
                RoundedRectangle(cornerRadius: 20)
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [.white, rowViewModel.color]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
            }
        )
        .padding(.horizontal)
    }
}

// ViewModifier 在这里是 Modifier 的通用配置, 但其实也可以当做 View 的工厂方法.
struct ToolButtonModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.system(size: 25))
            .foregroundColor(.white)
            .frame(width: 30, height: 30)
    }
}

