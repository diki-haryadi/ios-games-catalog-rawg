//
//  ImageUtility.swift
//  GameCatalog
//
//  Created on 03/04/25.
//

import Foundation
import UIKit

class ImageUtility {
    
    // Singleton instance
    static let shared = ImageUtility()
    
    // In-memory cache to store previously loaded images
    private let imageCache = NSCache<NSString, UIImage>()
    
    // Session used for fetching images
    private let session: URLSession
    
    private init() {
        // Configure session for image loading
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 30.0
        configuration.requestCachePolicy = .returnCacheDataElseLoad
        session = URLSession(configuration: configuration)
        
        // Configure cache
        imageCache.countLimit = 100 // Max number of images to keep in memory
        imageCache.totalCostLimit = 50 * 1024 * 1024 // 50MB of memory for cache
        
        // Register for memory warning notifications
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(clearMemoryCache),
            name: UIApplication.didReceiveMemoryWarningNotification,
            object: nil
        )
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // Load image into UIImageView with error handling and retries
    func loadImage(from urlString: String?, into imageView: UIImageView, placeholder: UIImage? = nil) {
        // Record start time for performance tracking
        let startTime = Date()
        
        // Set default placeholder
        let defaultPlaceholder = placeholder ?? UIImage(named: "placeholder_image")
        imageView.image = defaultPlaceholder
        
        // Guard against nil or empty URL strings
        guard let urlString = urlString, !urlString.isEmpty else {
            print("ImageUtility: Empty or nil URL string provided")
            return
        }
        
        print("Attempting to load image from: \(urlString)")
        
        // Use cache key based on URL string
        let cacheKey = NSString(string: urlString)
        
        // Check if image is already in cache
        if let cachedImage = imageCache.object(forKey: cacheKey) {
            print("Image loaded from cache: \(urlString)")
            imageView.image = cachedImage
            return
        }
        
        // Create a URL object - first try direct creation
        let imageURL: URL
        if let directURL = URL(string: urlString) {
            // Direct URL creation succeeded
            imageURL = directURL
        } else {
            // Direct URL creation failed, try with encoding
            guard let encodedUrlString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
                  let encodedUrl = URL(string: encodedUrlString) else {
                print("ImageUtility: Invalid URL format even after encoding: \(urlString)")
                return
            }
            
            print("ImageUtility: URL required encoding: \(urlString) → \(encodedUrlString)")
            imageURL = encodedUrl
        }
        
        // Tag the image view with the current request URL to avoid stale images
        let requestID = UUID().uuidString
        imageView.accessibilityIdentifier = requestID
        
        // Create and start the data task
        let task = session.dataTask(with: imageURL) { [weak self] data, response, error in
            guard let self = self else { return }
            
            // Perform UI updates on main thread
            DispatchQueue.main.async {
                // Check if the image view was recycled for a different image
                if imageView.accessibilityIdentifier != requestID {
                    print("ImageView was recycled for a different request, aborting image update")
                    return
                }
                
                // Handle errors
                if let error = error {
                    let timeElapsed = Date().timeIntervalSince(startTime)
                    print("Image load failed after \(String(format: "%.2f", timeElapsed))s: \(error.localizedDescription)")
                    
                    // Try fallbacks for failed requests
                    self.tryLoadFallbackImage(into: imageView, originalUrl: imageURL)
                    return
                }
                
                // Check for valid HTTP response
                guard let httpResponse = response as? HTTPURLResponse else {
                    print("Invalid response type")
                    return
                }
                
                // Check for successful HTTP status code
                guard (200...299).contains(httpResponse.statusCode) else {
                    print("HTTP error: \(httpResponse.statusCode)")
                    
                    // Try fallbacks for unsuccessful responses
                    self.tryLoadFallbackImage(into: imageView, originalUrl: imageURL)
                    return
                }
                
                // Ensure we have data
                guard let data = data, !data.isEmpty else {
                    print("No image data received")
                    return
                }
                
                // Create image from data
                guard let image = UIImage(data: data) else {
                    print("Could not create image from data")
                    return
                }
                
                // Cache the image
                self.imageCache.setObject(image, forKey: cacheKey)
                
                // Update the image view
                let timeElapsed = Date().timeIntervalSince(startTime)
                print("Image loaded successfully in \(String(format: "%.2f", timeElapsed))s: \(imageURL.absoluteString)")
                print("Image size: \(image.size.width)x\(image.size.height)")
                
                // Animate image appearance
                UIView.transition(with: imageView, duration: 0.3, options: .transitionCrossDissolve, animations: {
                    imageView.image = image
                }, completion: nil)
            }
        }
        
        task.resume()
    }
    
    // Try to load from fallback sources when main image fails
    private func tryLoadFallbackImage(into imageView: UIImageView, originalUrl: URL) {
        // Check if we can use a different image source
        let urlString = originalUrl.absoluteString
        
        // Some APIs have alternative domain options, try switching domains
        if urlString.contains("media.rawg.io") {
            // Try an alternative domain if exists
            let alternativeUrl = urlString.replacingOccurrences(of: "media.rawg.io", with: "media.api.rawg.io")
            print("Trying alternative URL domain: \(alternativeUrl)")
            
            loadImage(from: alternativeUrl, into: imageView)
            return
        }
        
        // If we failed to load an HTTPS URL, try HTTP version as a last resort
        if urlString.hasPrefix("https://") {
            let httpUrl = urlString.replacingOccurrences(of: "https://", with: "http://")
            print("Trying HTTP fallback: \(httpUrl)")
            
            loadImage(from: httpUrl, into: imageView)
            return
        }
        
        print("All fallback attempts failed for image URL: \(urlString)")
    }
    
    // Clear the in-memory image cache (called on memory warnings)
    @objc func clearMemoryCache() {
        imageCache.removeAllObjects()
        print("🧹Memory cache cleared")
    }
    
    // Helper method to validate an image URL
    func isValidImageURL(_ urlString: String?) -> Bool {
        guard let urlString = urlString, !urlString.isEmpty else {
            return false
        }
        
        // First try direct URL creation
        if let _ = URL(string: urlString) {
            return true
        }
        
        // If that fails, try with percent encoding
        if let encodedString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
           let _ = URL(string: encodedString) {
            return true
        }
        
        return false
    }
}

// MARK: - UIImageView Extension for easier usage
extension UIImageView {
    // Convenience method to load images directly on UIImageView
    func loadGameImage(from urlString: String?, placeholder: UIImage? = nil) {
        ImageUtility.shared.loadImage(from: urlString, into: self, placeholder: placeholder)
    }
}
