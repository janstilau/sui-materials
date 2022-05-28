//
//  LoadingView.swift
//  PokeMaster
//
//  Created by 王 巍 on 2019/08/26.
//  Copyright © 2019 OneV's Den. All rights reserved.
//

import SwiftUI

struct LoadingView: View, Animatable {
    
    @State var imageIndex: Int = 0
    @State var disabled = false
    
    var body: some View {
        VStack {
            Image("loading-\(imageIndex % 4)")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 100, height: 100)
        }.onAppear {
            Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
                self.imageIndex = (self.imageIndex + 1) % 4
                // 在 onDisappear 中, 修改了自己的状态.
                // 在定时器的下一次回调中, 进行定时器的取消.
                if self.disabled {
                    timer.invalidate()
                }
            }
        }.onDisappear {
            self.disabled = true
        }
    }
}
