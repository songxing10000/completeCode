//
//  ViewController.swift
//  DocSwiftModel
//
//  Created by mac on 2023/10/23.
//

import Cocoa
import Highlightr

class ViewController: NSViewController {
    
    @IBOutlet weak var m_topLeftTextView: NSTextView!
    @IBOutlet weak var m_topRightTextView: NSTextView!
    @IBOutlet weak var m_bottomTextView: NSTextView!
    private lazy var m_topLeftCodeAttributedString: CodeAttributedString = {
        let storage = CodeAttributedString()
        storage.highlightr.setTheme(to: "tomorrow-night-bright")
        storage.highlightr.theme.codeFont = NSFont(name: "Menlo", size: 14)
        storage.language = "swift"
        return storage
    }()
    private lazy var m_topRightCodeAttributedString: CodeAttributedString = {
        let storage = CodeAttributedString()
        storage.highlightr.setTheme(to: "tomorrow-night-bright")
        storage.highlightr.theme.codeFont = NSFont(name: "Menlo", size: 14)
        storage.language = "swift"
        return storage
    }()
    private lazy var m_bottomCodeAttributedString: CodeAttributedString = {
        let storage = CodeAttributedString()
        storage.highlightr.setTheme(to: "tomorrow-night-bright")
        storage.highlightr.theme.codeFont = NSFont(name: "Menlo", size: 14)
        storage.language = "swift"
        return storage
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        config(textView: m_topLeftTextView)
        config(textView: m_topRightTextView)
        config(textView: m_bottomTextView)
        
        m_topLeftCodeAttributedString.addLayoutManager(m_topLeftTextView.layoutManager!)
        m_topRightCodeAttributedString.addLayoutManager(m_topRightTextView.layoutManager!)
        m_bottomCodeAttributedString.addLayoutManager(m_bottomTextView.layoutManager!)
        
        let attrContent = NSAttributedString(string: """
import Foundation
import ExCodable

struct PostReplyListRes: ExAutoCodable {
     
@ExCodable
var list: Array?
 
/// 评论id
@ExCodable
var id: String?

/// 动态id
@ExCodable
var post_id: String?

/// 用户id
@ExCodable
var user_id: String?

/// 评论内容
@ExCodable
var content: String?

/// 评论时间戳
@ExCodable
var timeline: Int?

@ExCodable
var picture_urls: String?

/// 点赞数量
@ExCodable
var like_count: Int?

/// 用户昵称
@ExCodable
var user_name: String?

/// 头像
@ExCodable
var head_image: String?

/// 回复对象昵称
@ExCodable
var reply_name: String?

/// 是否点赞
@ExCodable
var is_liked: Bool?

/// 是否是自己的评论
@ExCodable
var is_my: Bool?

/// 子回复列表
@ExCodable
var reply_list: Array?
 
@ExCodable
var post_id: String?

@ExCodable
var user_id: String?

@ExCodable
var content: String?

@ExCodable
var timeline: Int?

@ExCodable
var picture_urls: String?

@ExCodable
var like_count: object?

@ExCodable
var user_name: String?

@ExCodable
var head_image: String?

@ExCodable
var reply_name: String?

@ExCodable
var is_liked: Bool?

@ExCodable
var is_my: Bool?

@ExCodable
var time_str: String?

@ExCodable
var user_status: String?

/// 评论时间（展示用）
@ExCodable
var time_str: String?

/// 用户当前状态
@ExCodable
var user_status: String?

@ExCodable
var is_next: Bool?

}

""")
        m_topLeftTextView.textStorage?.setAttributedString(attrContent)
        
        
        let attrContent2 = NSAttributedString(string: """

struct ReplyListRes: ExAutoCodable {

    @ExCodable
    var is_next: Bool = false

    @ExCodable
    var list = [ReplyListResList]()
}

struct ReplyListResList: ExAutoCodable {

    @ExCodable
    var content: String?

    @ExCodable
    var head_image: String?

    @ExCodable
    var is_liked: Bool = false


    @ExCodable
    var is_my: Bool = false


    @ExCodable
    var like_count: Int?

    @ExCodable
    var picture_urls: String?

    @ExCodable
    var id: String?
    
    @ExCodable
    var post_id: String?

    @ExCodable
    var reply_list:[ReplyListResList]?

    @ExCodable
    var reply_name: String?

    @ExCodable
    var time_str: String?

    @ExCodable
    var timeline: Int?

    @ExCodable
    var user_id: String?

    @ExCodable
    var user_name: String?

    @ExCodable
    var user_status: String?
}

""")
        m_topRightTextView.textStorage?.setAttributedString(attrContent2)
    }
    private func config(textView: NSTextView?) {
        textView?.isAutomaticQuoteSubstitutionEnabled = false
        textView?.isContinuousSpellCheckingEnabled = false
        textView?.delegate = self
        textView?.setUpLineNumberView()
    }
    @IBAction func clickCopyBtn(_ sender: NSButton) {
        let task = Process()
        let processName = "siri" // 要检测的进程名称

                task.launchPath = "/usr/bin/pgrep"
                task.arguments = ["-i", processName]
                
                let pipe = Pipe()
                task.standardOutput = pipe
                task.launch()
                
                let data = pipe.fileHandleForReading.readDataToEndOfFile()
                let output = String(data: data, encoding: .utf8)?.trimmingCharacters(in: .whitespacesAndNewlines)
                
                if task.terminationStatus == 0 {
                    print("\(processName) 进程已找到！")
                    // 结束应用程序
                    let killTask = Process()
                    killTask.launchPath = "/usr/bin/pkill"
                    killTask.arguments = ["-f", processName]
                    killTask.launch()
                } else {
                    print("\(processName) 进程未找到！")
                }
        }
    @IBAction func clickRefreshBtn(_ sender: NSButton) {
        if m_topLeftTextView.string.contains("//") == true {
            mergeCodeFrom(docTextView: m_topLeftTextView, typeTextView: m_topRightTextView, outTextView: m_bottomTextView)
            return
        }
        if m_topRightTextView.string.contains("//") == true {
            mergeCodeFrom(docTextView: m_topRightTextView, typeTextView: m_topLeftTextView, outTextView: m_bottomTextView)
            return
        }
        
        Alert(msg: "没有找到注释")
        
    }
    private func Alert(msg:String) {
        
        let alert = NSAlert()
        alert.alertStyle = .critical
        alert.messageText = "出错了"
        alert.informativeText = msg
        alert.addButton(withTitle: "确定")
        alert.runModal()
        
    }
    
    private func mergeCodeFrom(docTextView: NSTextView, typeTextView: NSTextView, outTextView: NSTextView){
        
        let docInfo = docInfoFrom(docTextView: docTextView)
        var typeLines = typeTextView.string.split(separator: "\n").compactMap({String($0)})
        for (index, line) in typeLines.enumerated() {
            let pattern = #"var\s+(\w+):"#
            do {
                let regex = try NSRegularExpression(pattern: pattern, options: .dotMatchesLineSeparators)
                let matches = regex.matches(in: line, range: NSRange(line.startIndex..., in: line))
                
                for match in matches {
                    let commentRange = Range(match.range(at: 1), in: docTextView.string)!
                    let comment = line[commentRange].trimmingCharacters(in: .whitespacesAndNewlines)
                    if let doc = docInfo[comment], !doc.isEmpty {
                        if index - 1 >= 0 {
                            typeLines[index - 1] =  "\n    /// \(doc)\n\(typeLines[index - 1])"
                        }
                    }
                }
            } catch {
                print("error:", error)
            }
        }
        
        let attrContent2 = NSAttributedString(string: typeLines.joined(separator: "\n"))
        m_bottomTextView.textStorage?.setAttributedString(attrContent2)
    }
    private func docInfoFrom(docTextView:NSTextView) -> [String:String] {
        let pattern = #"/{3}\s+(.+?)\s+@ExCodable\s+var\s+(\w+):\s(\S+)\??\n"#
        var docInfo = [String:String]()
        
        do {
            let regex = try NSRegularExpression(pattern: pattern, options: .dotMatchesLineSeparators)
            let matches = regex.matches(in: docTextView.string, range: NSRange(docTextView.string.startIndex..., in: docTextView.string))
            
            for match in matches {
                let commentRange = Range(match.range(at: 1), in: docTextView.string)!
                let fieldNameRange = Range(match.range(at: 2), in: docTextView.string)!
                
                let comment = docTextView.string[commentRange].trimmingCharacters(in: .whitespacesAndNewlines)
                let fieldName = docTextView.string[fieldNameRange]
                let key = String(fieldName)
                if let oldValue = docInfo[key], !oldValue.isEmpty {
                    Alert(msg: "有相同的字段\(key)")
                } else {
                    docInfo[key] = comment
                }
                
                
            }
            
            
        } catch {
            print("error:", error)
        }
        return docInfo
        
    }
    
}

extension ViewController: NSTextViewDelegate {
    func textView(_ textView: NSTextView, clickedOnLink link: Any, at charIndex: Int) -> Bool {
        if let value = link as? String,
           let url = URL(string: value) {
            NSWorkspace.shared.open(url)
        }
        
        return true
    }
    
    func textDidChange(_ notification: Notification) {
        generateClasses()
    }
    private func generateClasses() {
        
    }
}
