//
//  SettingView.swift
//  PokeMaster
//
//  Created by 王 巍 on 2019/09/01.
//  Copyright © 2019 OneV's Den. All rights reserved.
//

import SwiftUI
import UIKit

// 一个纯 Model 类, 所有要存储的数据, 都使用 @Published 进行了标识.
class Settings: ObservableObject {
    @Published var accountBehavior = AccountBehavior.login
    @Published var email = ""
    @Published var password = ""
    @Published var verifyPassword = ""

    @Published var showEnglishName = true
    @Published var sorting = Sorting.id
    @Published var showFavoriteOnly = false
}

struct SettingView: View {
    @ObservedObject var settings = Settings()
    var body: some View {
        Form {
            accountSection
            optionSection
            actionSection
        }
    }

    var accountSection: some View {
        Section(header: Text("账户")) {
            // 无法自定义感觉.
            // 感觉, 一切都要使用 UIKit 进行包装要.
            // 然后, 把 Model 传入进去.
            // 这样没什么价值啊, 为了动态刷新.
            Picker(selection: $settings.accountBehavior, label: Text("")) {
                ForEach(Settings.AccountBehavior.allCases, id: \.self) {
                    Text($0.text)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            
            TextField("电子邮箱", text: $settings.email)
            SecureField("密码", text: $settings.password)
            if settings.accountBehavior == .register {
                SecureField("确认密码", text: $settings.verifyPassword)
            }
            Button(settings.accountBehavior.text) {
                print("登录/注册")
            }
        }
    }

    var optionSection: some View {
        Section(header: Text("选项")) {
            Toggle(isOn: $settings.showEnglishName) {
                Text("显示英文名")
            }
            Picker(selection: $settings.sorting, label: Text("排序方式")) {
                ForEach(Settings.Sorting.allCases, id: \.self) {
                    Text($0.text)
                }
            }
            Toggle(isOn: $settings.showFavoriteOnly) {
                Text("只显示收藏")
            }
        }
    }

    var actionSection: some View {
        Section {
            Button(action: {
                print("清空缓存")
            }) {
                Text("清空缓存").foregroundColor(.red)
            }
        }
    }
}

extension Settings {
    enum Sorting: CaseIterable {
        case id, name, color, favorite
        
        var text: String {
            switch self {
            case .id: return "ID"
            case .name: return "名字"
            case .color: return "颜色"
            case .favorite: return "最爱"
            }
        }
    }
}

extension Settings {
    enum AccountBehavior: CaseIterable {
        case register, login
        
        var text: String {
            switch self {
            case .register: return "注册"
            case .login: return "登录"
            }
        }
    }
}
