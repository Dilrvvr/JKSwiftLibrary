//
//  JKUIView.swift
//  JKSwiftLibrary
//
//  Created by albert on 2021/9/17.
//

import UIKit

open class JKUIView: UIView {
    
    // MARK:
    // MARK: - Public Property
    
    /// backgroundView
    open private(set) lazy var backgroundView: UIView = {
        
        let backgroundView = UIView()
        
        backgroundView.isUserInteractionEnabled = false
        
        return backgroundView
    }()
    
    /// contentView
    open private(set) lazy var contentView: UIView = {
        
        let contentView = UIView()
        
        return contentView
    }()
    
    // MARK:
    // MARK: - Public Methods
    
    
    
    // MARK:
    // MARK: - Override
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        initialization()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        initialization()
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        
        backgroundView.frame = bounds
        contentView.frame = bounds
    }
    
    // MARK:
    // MARK: - Private Methods
    
    
    
    // MARK:
    // MARK: - Private Selector
    
    
    
    // MARK:
    // MARK: - Initialization & Build UI
    
    /// 初始化自身属性 交给子类重写 super自动调用该方法 注意调用super
    open func initializeProperty() {
        
    }
    
    /// 构造函数初始化时调用 注意调用super
    open func initialization() {
        
        initializeProperty()
        createUI()
        layoutUI()
        initializeUIData()
    }
    
    /// 创建UI 交给子类重写 super自动调用该方法 注意调用super
    open func createUI() {
        
        insertSubview(backgroundView, at: 0)
        insertSubview(contentView, at: 1)
    }
    
    /// 布局UI 交给子类重写 super自动调用该方法 注意调用super
    open func layoutUI() {
        
    }
    
    /// 初始化UI数据 交给子类重写 super自动调用该方法 注意调用super
    open func initializeUIData() {
        
    }
    
    // MARK:
    // MARK: - Private Property
    
    
}
