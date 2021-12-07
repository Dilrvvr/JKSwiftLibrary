//
//  JKJSONUtility.swift
//  JKSwiftLibrary
//
//  Created by albert on 2021/12/7.
//

import Foundation

public struct JKJSONUtility {
    
    /// string -> json object
    public static func toJsonObject(_ text: String?) -> Any? {
        
        guard let jsonString = text,
              let data = jsonString.data(using: .utf8) else {
                  
                  return nil
              }
        
        do {
            
            var options = JSONSerialization.ReadingOptions(rawValue: 0)
            
            if #available(iOS 15.0, *) {
                
                options = .json5Allowed
            }
            
            let jsonObject = try JSONSerialization.jsonObject(with: data, options: options)
            
            return jsonObject
            
        } catch {
            
            return nil
        }
    }
    
    /// object -> json string
    public static func toJsonString(_ obj: Any?) -> String? {
        
        guard let data = toJsonData(obj),
              let jsonString = String(data: data, encoding: .utf8) else {
                  
                  return nil
              }
        
        return jsonString
    }
    
    /// object -> json data
    public static func toJsonData(_ obj: Any?) -> Data? {
        
        guard let jsonObject = obj else {
            
            return nil
        }
        
        let isValid = JSONSerialization.isValidJSONObject(jsonObject)
        
        guard isValid else {
            
            return nil
        }
        
        do {
            
            let data = try JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted)
            
            return data
            
        } catch {
            
            return nil
        }
    }
    
    /// json object -> sand box
    public static func writeJsonObjectToPath(obj: Any?,
                                             path: String?,
                                             options: Data.WritingOptions = []) -> Bool {
        
        guard let data = toJsonData(obj) else {
            
            return false
        }
        
        return writeDataToPath(data: data, path: path, options: options)
    }
    
    /// data -> sand box
    public static func writeDataToPath(data: Data?,
                                       path: String?,
                                       options: Data.WritingOptions = []) -> Bool {
        
        guard let realData = data,
              let filePath = path else {
                  
                  return false
              }
        
        let isWritable = FileManager.default.isWritableFile(atPath: filePath)
        
        guard isWritable else {
            
            return false
        }
        
        let url = URL(fileURLWithPath: filePath)
        
        do {
            
            try realData.write(to: url, options: options)
            
            return true
            
        } catch {
            
            return false
        }
    }
}
