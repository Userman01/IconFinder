//
//  ImageView.swift
//  UnsplashApp
//
//  Created by Петр Постников on 30.03.2024.
//

import UIKit

extension UIImageView {
    func downloadImage(from url: URL, id: Int) {
        if let data = DataImageStore.dataImageStore.images[id] {
            if let data {
                self.image = UIImage(data: data)
            }
        } else {
            ImageProvider.fetchImage(from: url) { data, error in
                guard let data, error == nil else {
                    DispatchQueue.main.async() { [weak self] in
                        let image = UIImage(systemName: "xmark.app.fill")?.withTintColor(.black, renderingMode: .alwaysOriginal)
                        self?.image = image
                        guard let data = image?.pngData() else { return }
                        DataImageStore.dataImageStore.images[id] = data
                    }
                    return
                }
                DispatchQueue.main.async() { [weak self] in
                    guard let image = UIImage(data: data) else {
                        let image = UIImage(systemName: "xmark.app.fill")?.withTintColor(.black, renderingMode: .alwaysOriginal)
                        self?.image = image
                        guard let data = image?.pngData() else { return }
                        DataImageStore.dataImageStore.images[id] = data
                        return
                    }
                    self?.image = image
                    DataImageStore.dataImageStore.images[id] = data
                }
            }
        }
    }
}
