//
//  utils.swift
//  mlDiagnostic
//
//  Created by 全峰毅 on 10/27/23.
//

import Foundation
import UIKit

func imgToString (img: UIImage) -> String {
    return img.jpegData(compressionQuality: 1)?.base64EncodedString() ?? ""
}
func base64toUIImage(base64pic picture: String?) -> UIImage {
    guard let picture = picture else {
        return UIImage(named: Setting.appIconName)!
    }

    guard let imgData = Data(base64Encoded: picture, options: .ignoreUnknownCharacters) else {
        print("Failed to convert base64 string to Data.")
        return UIImage(named: Setting.appIconName)!
    }

    guard let image = UIImage(data: imgData) else {
        print("Failed to create UIImage from base64 string.")
        return UIImage(named: Setting.appIconName)!
    }
    return image
}

let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .short
    return formatter
}()
