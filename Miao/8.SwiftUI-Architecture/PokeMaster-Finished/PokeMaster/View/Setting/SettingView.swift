//
//  SettingView.swift
//  PokeMaster
//
//  Created by 王 巍 on 2019/09/01.
//  Copyright © 2019 OneV's Den. All rights reserved.
//

import SwiftUI

struct SettingView: View {

    @EnvironmentObject var storeViewModel: Store
    
    // 任何, 需要 Binding 的控件, 使用该值.
    // 可以实现属性的连接寻找.
    var settingsBinding: Binding<AppState.Settings> {
        $storeViewModel.appState.settings
    }
    // 当, 仅仅是进行展示的时候, 使用该值.
    var settingsShowing: AppState.Settings {
        storeViewModel.appState.settings
    }

    var body: some View {
        Form {
            accountSection
            optionSection
            actionSection
        }
        // 如果, settingsBinding.loginError 有值的时候, 进行 弹框的触发.
        // 这种设计, 感觉有点过分. 因为是否有错误, 个人感觉是不需要存储的 Model 内部的. 
        .alert(item: settingsBinding.loginError) { error in
            Alert(title: Text(error.localizedDescription))
        }
    }

    var accountSection: some View {
        Section(header: Text("账户")) {
            if settingsShowing.loginUser == nil {
                Picker(selection: settingsBinding.currentBehavior, label: Text("")) {
                    ForEach(AppState.Settings.AccountBehavior.allCases, id: \.self) {
                        Text($0.text)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                TextField("电子邮箱", text: settingsBinding.email)
                SecureField("密码", text: settingsBinding.password)
                if settingsShowing.currentBehavior == .register {
                    SecureField("确认密码", text: settingsBinding.verifyPassword)
                }
                if settingsShowing.loginRequesting {
                    Text("登录中...")
                } else {
                    // View Action
                    Button(settingsShowing.currentBehavior.text) {
                        // View Action -> 触发 Model Action.
                        // storeViewModel 将所有的 Model Action 统一到了一个函数内.
                        // 在 Dispatch 方法内, 进行了 ViewModel 中数据的修改, 以及异步操作的触发. 
                        self.storeViewModel.dispatch(
                            .login(
                                email: self.settingsShowing.email,
                                password: self.settingsShowing.password
                            )
                        )
                    }
                }
            } else {
                Text(settingsShowing.loginUser!.email)
                Button("注销") {
                    print("注销")
                }
            }
        }
    }

    var optionSection: some View {
        Section(header: Text("选项")) {
            Toggle(isOn: settingsBinding.showEnglishName) {
                Text("显示英文名")
            }
            Picker(selection: settingsBinding.sortingWay, label: Text("排序方式")) {
                ForEach(AppState.Settings.Sorting.allCases, id: \.self) {
                    Text($0.text)
                }
            }
            Toggle(isOn: settingsBinding.showFavoriteOnly) {
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

extension AppState.Settings.Sorting {
    var text: String {
        switch self {
        case .id: return "ID"
        case .name: return "名字"
        case .color: return "颜色"
        case .favorite: return "最爱"
        }
    }
}

extension AppState.Settings.AccountBehavior {
    var text: String {
        switch self {
        case .register: return "注册"
        case .login: return "登录"
        }
    }
}
