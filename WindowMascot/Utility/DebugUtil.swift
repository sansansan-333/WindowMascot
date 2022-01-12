//
//  DebugUtil.swift
//  MacAppTest
//
//  Created on 2021/12/17
//
//

import Foundation

///
/// implementation of writing append is temporary
class Logger{
    static let shared = Logger(append: true)
    
    private var fileDir: String
    private var log: String = ""
    private var append: Bool
    private var isDisabled: Bool
    
    init(fileDir: String, append: Bool){
        self.fileDir = fileDir
        self.append = append
        self.isDisabled = false
    }
    
    init(append: Bool){
        self.fileDir = FileManager.default.currentDirectoryPath
        self.append = append
        self.isDisabled = false
    }
    
    @discardableResult
    public func write(file: String = "log.txt", log: String) -> Bool {
        if isDisabled{
            return false
        }
        
        var path: String
        if fileDir.last != "/" {
            path = fileDir + "/" + file
        }else{
            path = fileDir + file
        }
        
        if !FileManager.default.fileExists(atPath: path){
            FileManager.default.createFile(atPath: path, contents: "".data(using: .utf8))
        }
        
        do {
            var logStr: String
            if append{
                self.log += log
                logStr = self.log
            }else{
                logStr = log
            }
            try NSString(string: logStr).write(toFile: path, atomically: false, encoding: String.Encoding.utf8.rawValue)
        } catch {
            return false
        }
        return true
    }
    
    func disable(){
        isDisabled = true
    }
    
    func activate(){
        isDisabled = false
    }
}
