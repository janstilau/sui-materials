//
//  RepositoryListRow.swift
//  SwiftUI-MVVM
//
//  Created by Yusuke Kita on 6/5/19.
//  Copyright © 2019 Yusuke Kita. All rights reserved.
//

import Foundation
import SwiftUI

struct RepositoryListRow: View {

    @State var repository: Repository

    var body: some View {
        /*
         NavigationLink
         public init(@ViewBuilder destination: () -> Destination, @ViewBuilder label: () -> Label)
         NavigationLink 中, 存储的是两个 Block. 所以, 并不是在 cell 显示的时候, 就把对应的 DetailView 就创建了出来.
         */
        NavigationLink(destination: RepositoryDetailView(
            viewModel: .init(repository: repository))) {
            Text(repository.fullName)
        }
    }
}

#if DEBUG
struct RepositoryListRow_Previews : PreviewProvider {
    static var previews: some View {
        // 在 Preview 里面, 使用假数据.
        RepositoryListRow(repository:
            Repository(
                id: 1,
                fullName: "foo",
                owner: User(id: 1, login: "bar", avatarUrl: URL(string: "baz")!)
            )
        )
    }
}
#endif
