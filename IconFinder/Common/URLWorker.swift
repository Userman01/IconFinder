//
//  URLWorker.swift
//  IconFinder
//
//  Created by Петр Постников on 22.06.2024.
//

import Foundation

final class URLWorker {
    func getURLImage(icon: Icon, format: PurpleFormat) -> String? {
        return icon.rasterSizes.last?.formats.first(where: {
            $0.format.rawValue == format.rawValue
        })?.downloadURL
    }
}
