

/*
 extractViews 方法, 会在各个 Stack View 在创建 NodeTree 的时候被使用. 
 */
internal struct ViewExtractor<Content>: View where Content: View {
    internal static func extractViews(contents: Content) -> [ViewBuildable] {
        var buildables = [ViewBuildable]()
        /*
         Stack View 的 contents 可能是 TupleView.
         */
        
        
        if let element = contents as? ViewBuildable {
            // 如果是 TupleView, TupleView 本身是 ViewBuildable 的
            buildables.append(element)
        } else if let element = contents.body as? ViewBuildable {
            // 如果是 CustomView. 那么它的 Body 返回的, 一定是 ViewBuildable.
            buildables.append(element)
        } else {
            print(contents)
            print("No Idea what's inside.")
        }
        
        return buildables
    }
}

extension ViewExtractor {
    internal var body: Never {
        fatalError()
    }
}
