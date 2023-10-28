//
//  NSTextViewEx.swift
//  completeCode
//
//  Created by mac on 2023/10/23.
//

import Cocoa

var LineNumberViewAssocObjKey: UInt8 = 0

extension NSTextView {
    var lineNumberView: LineNumberRulerView {
        get {
            return objc_getAssociatedObject(self, &LineNumberViewAssocObjKey) as! LineNumberRulerView
        }
        set {
            objc_setAssociatedObject(
                self,
                &LineNumberViewAssocObjKey,
                newValue,
                .OBJC_ASSOCIATION_RETAIN_NONATOMIC
            )
        }
    }
    
    func setUpLineNumberView() {
        if let scrollView = enclosingScrollView {
            lineNumberView = LineNumberRulerView(textView: self)
            
            scrollView.hasVerticalRuler = true
            scrollView.rulersVisible = true
            scrollView.verticalRulerView = lineNumberView
        }
        
        postsFrameChangedNotifications = true
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(lnv_frameDidChange),
            name: NSView.frameDidChangeNotification,
            object: self
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(lnv_textDidChange),
            name: NSText.didChangeNotification,
            object: self
        )
    }
    
    @objc func lnv_frameDidChange(notification: NSNotification) {
        lineNumberView.needsDisplay = true
    }
    
    @objc func lnv_textDidChange(notification: NSNotification) {
        lineNumberView.needsDisplay = true
    }
}
