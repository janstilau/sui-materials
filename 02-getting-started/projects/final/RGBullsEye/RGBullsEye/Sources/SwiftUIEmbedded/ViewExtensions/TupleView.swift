

extension TupleView: ViewBuildable {
    public func buildDebugTree(tree: inout ViewNode, parent: ViewNode) {
        // Tuple 里面, 使用 Mirror 将所有的 View 的 SubView 进行了抽取. 
        for child in Mirror(reflecting: value).children {
            if let viewBuildable = child.value as? ViewBuildable {
                viewBuildable.buildDebugTree(tree: &tree, parent: parent)
            } else {
                print("Can't render custom views, yet.")
            }
        }
    }
}
