//
//  UIImage+EasyAdd.swift
//  EasyCoding
//
//  Created by Fanxx on 2018/3/23.
//  Copyright © 2018年 fanxx. All rights reserved.
//

import UIKit

extension EasyCoding where Base: UIImage {
    ///获取当前启动页
    public static func launch() -> UIImage? {
        if let n = self.launchImageName() {
            return UIImage(named:n)
        }else{
            return nil
        }
    }
    ///获取启动页名称
    private static func launchImageName() -> String? {
        var viewSize = UIScreen.main.bounds.size
        var viewOrientation = "Portrait"
        if UIDevice.current.orientation.isLandscape {
            viewSize = CGSize(width:viewSize.height, height:viewSize.width)
            viewOrientation = "Landscape"
        }
    
        if let imagesDict = Bundle.main.infoDictionary?["UILaunchImages"] as? [[String:Any]] {
            for dict in imagesDict {
                if let ss = dict["UILaunchImageSize"] as? String,let so = dict["UILaunchImageOrientation"] as? String {
                    let imageSize = NSCoder.cgSize(for: ss)
                    if imageSize.equalTo(viewSize) && viewOrientation == so {
                        return dict["UILaunchImageName"] as? String
                    }
                }
            }
        }
        return nil
    }
    ///生成虚线图
    public static func dottedLine(color:UIColor,size:CGSize,spacing:CGFloat) -> UIImage? {
        UIGraphicsBeginImageContext(CGSize(width: size.width + spacing, height: size.height + spacing))
        if let context = UIGraphicsGetCurrentContext() {
            //第一行
            context.beginPath()
            context.setLineWidth(size.height)
            context.setStrokeColor(color.cgColor)
            context.setLineDash(phase: 0, lengths: [size.width,spacing])
            context.move(to: CGPoint(x: 0, y: size.height / 2))
            context.addLine(to: CGPoint(x: size.width + spacing, y: size.height / 2))
            context.strokePath()
            //第二行
            context.setLineWidth(spacing)
            context.setStrokeColor(color.cgColor)
            context.setLineDash(phase: 0, lengths: [spacing,size.width])
            context.move(to: CGPoint(x: -size.width, y: size.height + spacing / 2))
            context.addLine(to: CGPoint(x: size.width + spacing, y: size.height + spacing / 2))
            context.strokePath()
            let image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return image
        }
        return nil
    }
    public static func textMask(_ text:NSAttributedString, size: CGSize = CGSize(width: 1000, height: 1000),color: UIColor = UIColor(white: 0, alpha: 0.5)) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
        if let context = UIGraphicsGetCurrentContext() {
            context.setFillColor(color.cgColor)
            context.fill(CGRect(origin: .zero, size: size))
            
            let rect = text.boundingRect(with: size, options: [], context: nil)
            let point = CGPoint(x: (size.width - rect.size.width) / 2, y: (size.height - rect.size.height) / 2)
            text.draw(in: CGRect(origin: point, size: rect.size))
            
            let image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return image
        }
        return nil
    }
    public static func color(_ color: UIColor, size: CGSize = .easy(1)) -> UIImage {
        if (size.width <= 0 || size.height <= 0) {
            preconditionFailure("This size: \(size) is not invalid")
        }
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0)
        let context = UIGraphicsGetCurrentContext()!
        context.setFillColor(color.cgColor)
        context.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    ///按指定的圆角裁切
    public func clip(corner: CGFloat) -> UIImage {
        let width = self.base.size.width
        let height = self.base.size.height
        let size = CGSize(width: width, height: height)
        UIGraphicsBeginImageContextWithOptions(size, false, self.base.scale)
        let context = UIGraphicsGetCurrentContext()!
        context.move(to: .easy(0, corner))
        context.addArc(tangent1End: .zero, tangent2End: .easy(corner, 0), radius: corner)
        context.addLine(to: .easy(width - corner, 0))
        context.addArc(tangent1End: .easy(width, 0), tangent2End: .easy(width, corner), radius: corner)
        context.addLine(to: .easy(width, height - corner))
        context.addArc(tangent1End: .easy(width, height), tangent2End: .easy(width - corner, height), radius: corner)
        context.addLine(to: .easy(corner, height))
        context.addArc(tangent1End: .easy(0, height), tangent2End: .easy(0, height - corner), radius: corner)
        context.addLine(to: .easy(0, corner))
        context.closePath()
        //先裁剪context，再画图，就会在裁剪后的path中画
        context.clip()
        self.base.draw(in: .easy(width, height))
        context.drawPath(using: .fill)

        let image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()

        return image;
    }
    public func resize(insets:UIEdgeInsets) -> UIImage {
        return self.base.resizableImage(withCapInsets: insets)
    }
    public func by(tint color: UIColor) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.base.size, false, self.base.scale)
        let rect = CGRect(origin: .zero, size: self.base.size)
        color.set()
        UIRectFill(rect)
        self.base.draw(at: .zero, blendMode: .destinationIn, alpha: 1)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage ?? self.base
    }
    ///旋转图片
    public func by(rotate radians: CGFloat) -> UIImage {
        let width = self.base.cgImage!.width
        let height = self.base.cgImage!.height
        let newRect = CGRect(x: 0, y: 0, width: width, height: height)
        newRect.applying(.init(rotationAngle: radians))
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(rawValue:
            CGBitmapInfo.byteOrderMask.rawValue |
                CGImageAlphaInfo.premultipliedFirst.rawValue)
        let context = CGContext(data: nil, width: Int(newRect.size.width), height: Int(newRect.size.height), bitsPerComponent: 8, bytesPerRow: Int(newRect.size.width) * 4, space: colorSpace, bitmapInfo: bitmapInfo.rawValue)!
        
        context.setShouldAntialias(true)
        context.setAllowsAntialiasing(true)
        context.interpolationQuality = .high
        
        context.translateBy(x: newRect.size.width * 0.5, y: newRect.size.height * 0.5)
        context.rotate(by: radians)
        
        context.draw(self.base.cgImage!, in: CGRect(x: -(CGFloat(width) * 0.5), y: -(CGFloat(height) * 0.5), width: CGFloat(width), height: CGFloat(height)))
        
        let imgRef = context.makeImage()
        let img = UIImage(cgImage: imgRef!, scale: self.base.scale, orientation: self.base.imageOrientation)
        return img
    }
    ///旋转图片
    public func byRotateLeft90() -> UIImage {
        self.by(rotate: CGFloat.easy.degreesToRadians(90))
    }
    ///旋转图片
    public func byRotateRight90() -> UIImage {
        self.by(rotate: CGFloat.easy.degreesToRadians(-90))
    }
    ///旋转图片
    public func byRotate180() -> UIImage {
        self.by(rotate: CGFloat.easy.degreesToRadians(180))
    }
}
