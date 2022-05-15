

extension ForEach: ViewBuildable {
    public func buildDebugTree(tree: inout ViewNode, parent: ViewNode) {
        data.forEach { body in
            if let element = content(body) as? ViewBuildable {
                // 直到这里, 才是 ForEach 真正起作用的时候.
                // 实际上, HStack 里面, Item, ForEach, Item. HStack 里面就是存储了一个 Tuple, Tuple 里面, 就是三个 Item.
                // 真正的 ForEach 变为了 View, 是在这里才真正起到了作用. 
                element.buildDebugTree(tree: &tree, parent: parent)
            }
        }
    }
}
