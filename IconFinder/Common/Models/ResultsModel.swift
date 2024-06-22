//
//  ResultsModel.swift
//  IconFinder
//
//  Created by Петр Постников on 22.06.2024.
//

import Foundation

// MARK: - ResultsModel
struct ResultsModel: Codable {
    let totalCount: Int
    let icons: [Icon]

    enum CodingKeys: String, CodingKey {
        case totalCount = "total_count"
        case icons
    }
}

// MARK: - Icon
struct Icon: Codable {
    let categories: [Category]
    let containers: [Container]
    let tags: [String]
    let publishedAt: String
    let type: TypeEnum
    let iconID: Int
    let vectorSizes: [VectorSize]
    let styles: [Category]
    let isPremium: Bool
    let prices: [Price]?
    let rasterSizes: [RasterSize]
    let isIconGlyph: Bool

    enum CodingKeys: String, CodingKey {
        case categories, containers, tags
        case publishedAt = "published_at"
        case type
        case iconID = "icon_id"
        case vectorSizes = "vector_sizes"
        case styles
        case isPremium = "is_premium"
        case prices
        case rasterSizes = "raster_sizes"
        case isIconGlyph = "is_icon_glyph"
    }
}

// MARK: - Category
struct Category: Codable {
    let name, identifier: String
}

// MARK: - Container
struct Container: Codable {
    let format: ContainerFormat
    let downloadURL: String

    enum CodingKeys: String, CodingKey {
        case format
        case downloadURL = "download_url"
    }
}

enum ContainerFormat: String, Codable {
    case ai = "ai"
    case csh = "csh"
    case icns = "icns"
    case ico = "ico"
    case svg = "svg"
}

// MARK: - Price
struct Price: Codable {
    let price: Int
    let currency: String
    let license: License
}

// MARK: - License
struct License: Codable {
    let name, scope: String
    let licenseID: Int
    let url: String

    enum CodingKeys: String, CodingKey {
        case name, scope
        case licenseID = "license_id"
        case url
    }
}

// MARK: - RasterSize
struct RasterSize: Codable {
    let sizeHeight: Int
    let formats: [FormatElement]
    let size, sizeWidth: Int

    enum CodingKeys: String, CodingKey {
        case sizeHeight = "size_height"
        case formats, size
        case sizeWidth = "size_width"
    }
}

// MARK: - FormatElement
struct FormatElement: Codable {
    let previewURL: String
    let format: PurpleFormat
    let downloadURL: String

    enum CodingKeys: String, CodingKey {
        case previewURL = "preview_url"
        case format
        case downloadURL = "download_url"
    }
}

enum PurpleFormat: String, Codable {
    case png = "png"
}

enum TypeEnum: String, Codable {
    case vector = "vector"
}

// MARK: - VectorSize
struct VectorSize: Codable {
    let sizeHeight: Int
    let formats: [Container]
    let size, sizeWidth: Int
    let targetSizes: [[Int]]

    enum CodingKeys: String, CodingKey {
        case sizeHeight = "size_height"
        case formats, size
        case sizeWidth = "size_width"
        case targetSizes = "target_sizes"
    }
}
