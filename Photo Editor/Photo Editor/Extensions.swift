//
//  Extensions.swift
//  Photo Editor
//
//  Created by Hakan Karakaya on 20.07.2020.
//  Copyright © 2020 Mohamed Hamed. All rights reserved.
//

import UIKit

extension UIImage {
    /// will load an image from a remote URL
    /// - parameter fromURL: url to load from
    /// - parameter completionHandler: completion handler for when the image is done loading.
    /// - parameter image: UIImage? that was retrieved, or nil on error
    /// - parameter error: LocalizedError? that is nil on success, or an error message on failure.
    /// example
    /// ```
    /// guard let url = URL(string: "http://localhost/Shows/Animaniacs.jpg") else {
    ///    print("url error")
    ///    return
    /// }
    /// UIImage.loadImage(fromURL: url, completionHandler: { (image, error) in
    ///     if let image = image {
    ///         // if you are showing the image in a UIImage on the screen,
    ///         // remember that here we are not in the main thread, so you
    ///         // will have to run it in the main thread
    ///         DispatchQueue.main.async {
    ///             imageView.image = image
    ///         }
    ///     } else {
    ///         print(error?.errorDescription ?? "Unknown Error")
    ///     }
    /// })
    /// ```
    public static func loadImage(
        fromURL:URL,
        completionHandler: @escaping (_ image:UIImage?, _ error:LocalizedError?)->Void
    ) {
        URLSession(configuration: .default)
        .dataTask(with: fromURL) { (data, response, error) in
            if let error = error {
                completionHandler(nil, LoadImageError(error.localizedDescription))
                return
            }
            if let response = response as? HTTPURLResponse {
                if response.statusCode != 200 {
                    completionHandler(nil,
                        LoadImageError("bad response \(response.statusCode) - \(response.description)"))
                    return
                }
                if let data = data {
                    if let image = UIImage(data: data) {
                        completionHandler(image, nil)
                        return
                    }
                    if response.mimeType?.contains("text") ?? false ||
                        response.mimeType?.contains("json") ?? false {
                        completionHandler(nil,
                                          LoadImageError("unable to convert data " +
                                            (String(data: data, encoding: .utf8) ?? "\(data)") +
                                            " to image"))
                        return
                    }
                    completionHandler(nil,
                        LoadImageError("unable to convert data \(data) to image"))
                    return
                }
                completionHandler(nil,
                    LoadImageError("unable to retrieve response data"))
                return
            }
            completionHandler(nil,
                    LoadImageError("unknown response type"))
        }.resume()
    }
}

extension UIImageView {
    /// will load the image of the UIImageView with the image at url
    /// - parameter url: URL to get image from
    /// - parameter completionHandler: completion handler for when the image is done loading.
    /// - parameter error: LocalizedError? that is nil on success, or an error message on failure.
    /// example
    /// ```
    /// if let url = URL(string: "http://somewhere.com/images/someimage.jpg")
    ///     self.imageView.image(fromURL: url) { (error) in
    ///         if let error = error {
    ///             print(error.errorDescription)
    ///         }
    ///     }
    /// }
    /// ```
    public func image(
        fromURL url: URL,
        completionHandler:((_ error:LocalizedError?)->Void)? = nil
    ) {
        let activityIndicator = UIActivityIndicatorView(style: .gray)
        activityIndicator.frame = CGRect.init(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height)
        activityIndicator.startAnimating()
        if self.image == nil {
            self.addSubview(activityIndicator)
        }
        UIImage.loadImage(fromURL: url) { (image, error) in
            if let image = image {
                DispatchQueue.main.async {
                    activityIndicator.removeFromSuperview()
                    self.image = image
                    completionHandler?(nil)
                }
            } else {
                completionHandler?(LoadImageError("ERROR: \(error?.errorDescription ?? "unknown")"))
            }
        }
    }
    /// will load the image of the UIImageView with the image at urlString
    /// - parameter urlString: URL string to get image from
    /// - parameter completionHandler: completion handler for when the image is done loading.
    /// - parameter error: LocalizedError? that is nil on success, or an error message on failure.
    /// example
    /// ```
    /// self.imageView.image(fromURLString: "http://somewhere.com/images/someimage.jpg") { (error) in
    ///     if let error = error {
    ///         print(error.errorDescription)
    ///     }
    /// }
    /// ```
    public func image(
        fromURLString urlString:String,
        completionHandler:((_ error:LocalizedError?)->Void)? = nil
    ) {
        guard let url = URL(string: urlString) else {
            completionHandler?(LoadImageError("Bad url string: \(urlString)"))
            return
        }
        self.image(fromURL: url) { (error) in
            completionHandler?(error)
        }
    }
}

// MARK:- Error handling
/// contains a LocalizedError for when the load image extentions fail.
public struct LoadImageError: LocalizedError {
    private let message:String
    public init(_ message:String) {
        self.message = message
    }
    public var errorDescription: String? { get { return self.message } }
    public var failureReason: String? { get { return self.message } }
    public var recoverySuggestion: String? { get { return self.message } }
    public var helpAnchor: String? { get { return self.message } }
}



