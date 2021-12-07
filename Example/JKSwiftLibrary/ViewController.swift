//
//  ViewController.swift
//  JKSwiftLibrary
//
//  Created by albert on 12/07/2021.
//  Copyright (c) 2021 albert. All rights reserved.
//

import UIKit
import JKSwiftLibrary

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let image = JKGeneralUtility.resourceImageNamed("jk_blank") {
            
            print("image: \(image)")
            
            if let data = image.jpegData(compressionQuality: 1.0) {
                
                print("image 大小: \(data.count) bytes")
            }
        }
        
        let window = JKKeyWindow
        
        print("JKKeyWindow: \(window)")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

