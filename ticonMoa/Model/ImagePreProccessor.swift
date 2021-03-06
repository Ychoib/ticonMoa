//
//  ImagePreProccessor.swift
//  ticonMoa
//
//  Created by 채훈기 on 2021/04/12.
//

import UIKit


func scaleAndOrient(image: UIImage) -> UIImage {
    
    // Set a default value for limiting image size.
    let maxResolution: CGFloat = 640
    
    guard let cgImage = image.cgImage else {
        print("UIImage has no CGImage backing it!")
        return image
    }
    
    // Compute parameters for transform.
    let width = CGFloat(cgImage.width)
    let height = CGFloat(cgImage.height)
    var transform = CGAffineTransform.identity
    
    var bounds = CGRect(x: 0, y: 0, width: width, height: height)
    
    if width > maxResolution ||
        height > maxResolution {
        let ratio = width / height
        if width > height {
            bounds.size.width = maxResolution
            bounds.size.height = round(maxResolution / ratio)
        } else {
            bounds.size.width = round(maxResolution * ratio)
            bounds.size.height = maxResolution
        }
    }
    
    let scaleRatio = bounds.size.width / width
    let orientation = image.imageOrientation
    switch orientation {
    case .up:
        transform = .identity
    case .down:
        transform = CGAffineTransform(translationX: width, y: height).rotated(by: .pi)
    case .left:
        let boundsHeight = bounds.size.height
        bounds.size.height = bounds.size.width
        bounds.size.width = boundsHeight
        transform = CGAffineTransform(translationX: 0, y: width).rotated(by: 3.0 * .pi / 2.0)
    case .right:
        let boundsHeight = bounds.size.height
        bounds.size.height = bounds.size.width
        bounds.size.width = boundsHeight
        transform = CGAffineTransform(translationX: height, y: 0).rotated(by: .pi / 2.0)
    case .upMirrored:
        transform = CGAffineTransform(translationX: width, y: 0).scaledBy(x: -1, y: 1)
    case .downMirrored:
        transform = CGAffineTransform(translationX: 0, y: height).scaledBy(x: 1, y: -1)
    case .leftMirrored:
        let boundsHeight = bounds.size.height
        bounds.size.height = bounds.size.width
        bounds.size.width = boundsHeight
        transform = CGAffineTransform(translationX: height, y: width).scaledBy(x: -1, y: 1).rotated(by: 3.0 * .pi / 2.0)
    case .rightMirrored:
        let boundsHeight = bounds.size.height
        bounds.size.height = bounds.size.width
        bounds.size.width = boundsHeight
        transform = CGAffineTransform(scaleX: -1, y: 1).rotated(by: .pi / 2.0)
    default:
        transform = .identity
    }
    
    return UIGraphicsImageRenderer(size: bounds.size).image { rendererContext in
        let context = rendererContext.cgContext
        
        if orientation == .right || orientation == .left {
            context.scaleBy(x: -scaleRatio, y: scaleRatio)
            context.translateBy(x: -height, y: 0)
        } else {
            context.scaleBy(x: scaleRatio, y: -scaleRatio)
            context.translateBy(x: 0, y: -height)
        }
        context.concatenate(transform)
        context.draw(cgImage, in: CGRect(x: 0, y: 0, width: width, height: height))
    }
}
