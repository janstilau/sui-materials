//
//  FileStorage.swift
//  PokeMaster
//
//  Created by 王 巍 on 2019/09/13.
//  Copyright © 2019 OneV's Den. All rights reserved.
//

import Foundation

@propertyWrapper
struct FileStorage<T: Codable> {
    var value: T?
    
    let directory: FileManager.SearchPathDirectory
    let fileName: String
    
    init(directory: FileManager.SearchPathDirectory, fileName: String) {
        // 在初始化的时候, 就进行了 Load 的操作.
        // 这是一个固定的套路, 那就是, 只 Load 一次. 
        value = try? FileHelper.loadJSON(from: directory, fileName: fileName)
        self.directory = directory
        self.fileName = fileName
    }
    
    var wrappedValue: T? {
        set {
            value = newValue
            if let value = newValue {
                try? FileHelper.writeJSON(value, to: directory, fileName: fileName)
            } else {
                try? FileHelper.delete(from: directory, fileName: fileName)
            }
        }
        
        get { value }
    }
}
