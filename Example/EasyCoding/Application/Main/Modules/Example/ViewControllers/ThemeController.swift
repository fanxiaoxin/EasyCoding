//
//  ThemeController.swift
//  EasyCoding_Example
//
//  Created by JY_NEW on 2021/1/9.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import Foundation
import EasyCoding

class ThemeController: ViewController<ThemeView> {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func onNavigationRight() {
        self.load(Theme2Controller())
    }
}
class ThemeView: Page {
    let label = UILabel.easy(.color(.white))
    let label2 = UILabel.easy(.color(.white))
    
    override func load() {
        super.load()
        self.easy.add(label, layout: .centerX, .centerY(-10))
            .next(label2, layout: .centerX, .bottomTop(20))
        label.theme.backgroundColor = .main
        label.theme.text = .main
        label2.theme.backgroundColor = .sub
        label2.theme.text = .sub
        
        self.navigationRight("下一页")
    }
}

class Theme2Controller: ViewController<Theme2View> {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.theme.title = .main
    }
    @objc func onChange() {
        switch ThemeManager.shared.theme {
        case .blue:
            ThemeManager.shared.theme = .red
        case .red:
            ThemeManager.shared.theme = .blue
        }
    }
}
class Theme2View: Page {
    let button = UIButton.easy(.text("换主题"), .color(.white))
    
    override func load() {
        super.load()
        
        let imageView = UIImageView()
        
        self.easy.add(button, layout: .center).next(imageView, layout: .centerX, .bottomTop(10))
        
        imageView.theme.image = .icon
        
        button.theme.set { (btn) in
            btn.easy(.color(ColorIndex.main.rawValue), .bg(ColorIndex.sub.rawValue))
        }
        
        self.bind(button, event: "Change")
    }
}

enum ThemeIndex:String, ECThemeTableType {
    typealias RawValue = String

    case blue = "蓝色版"
    case red = "红色版"
    
    static var current: ThemeIndex {
        return ThemeManager.shared.theme
    }
}

enum ColorIndex: ECThemeValueType {
    typealias ThemeTableType = ThemeIndex
    typealias RawValue = UIColor
    
    case main
    case sub
    
    var rawValue: UIColor {
        switch self.theme {
        case .blue:
            switch self {
            case .main: return .systemBlue
            case .sub: return .systemGreen
            }
        case .red:
            switch self {
            case .main: return .systemRed
            case .sub: return .systemOrange
            }
        }
    }
}

enum TextIndex: String, ECThemeValueType {
    typealias ThemeTableType = ThemeIndex
    
    case main
    case sub
    
    var rawValue: String {
        switch self.theme {
        case .blue:
            switch self {
            case .main: return "蓝色"
            case .sub: return "绿色"
            }
        case .red:
            switch self {
            case .main: return "红色"
            case .sub: return "橘色"
            }
        }
    }
}

enum ImageIndex: ECThemeValueType {
    typealias ThemeTableType = ThemeIndex
    typealias RawValue = UIImage?

    case icon
    case back
    
    var rawValue: UIImage? {
        switch self {
        case .icon: return UIImage(named: "未选图片")?.easy.by(tint: ColorIndex.main.rawValue)
        case .back: return UIImage(named: "返回")?.easy.by(tint: ColorIndex.sub.rawValue)
        }
    }
}

class ThemeManager: ECThemeManagerType {
    
    var theme: ThemeIndex = .blue {
        didSet {
            self.update()
        }
    }
    
    var targets: [ECThemeManagerTarget] = []
    
    static let shared = ThemeManager()
}
extension ThemeManager: ECThemeColorMapped, ECThemeStringMapped, ECThemeImageMapped {
    typealias ColorType = ColorIndex
    typealias StringType = TextIndex
    typealias ImageType = ImageIndex
}

protocol ViewThemeType { }
extension NSObject: ViewThemeType { }

extension ViewThemeType where Self: AnyObject {
    var theme: ECThemeSetter<Self, ThemeManager> {
        return ECThemeSetter(target: self, manager: .shared)
    }
}
