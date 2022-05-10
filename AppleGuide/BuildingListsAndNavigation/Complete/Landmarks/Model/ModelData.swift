/*
 See LICENSE folder for this sample’s licensing information.
 
 Abstract:
 Storage for model data.
 */

import Foundation

/*
 landmarkData 里面的数据, 都是格式化的, 阅读一点障碍都没有. 
 */

// 这是一个全局变量.
var landmarks: [Landmark] = load("landmarkData.json")

// 根据, 返回值的类型, 来推断出 T 的类型.
// 根据返回值类型, 来决定泛型里面的类型参数, 是一个非常非常通用的做法. 
func load<T: Decodable>(_ filename: String) -> T {
    let data: Data
    
    guard let file = Bundle.main.url(forResource: filename, withExtension: nil) else {
        fatalError("Couldn't find \(filename) in main bundle.")
    }
    
    do {
        data = try Data(contentsOf: file)
    } catch {
        fatalError("Couldn't load \(filename) from main bundle:\n\(error)")
    }
    
    do {
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    } catch {
        fatalError("Couldn't parse \(filename) as \(T.self):\n\(error)")
    }
}
