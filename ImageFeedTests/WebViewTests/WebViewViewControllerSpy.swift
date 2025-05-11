//
//  WebViewViewControllerSpy.swift
//  ImageFeedTests
//
//  Created by Main on 10.05.2025.
//

import Foundation
import ImageFeed

class WebViewViewControllerSpy: WebViewViewControllerProtocol {
    var presenter: ImageFeed.WebViewPresenterProtocol?
    var loadRequestCalled: Bool = false
    
    func load(request: URLRequest) {
        loadRequestCalled = true
    }
    
    func setProgressValue(_ newValue: Float) {
        
    }
    
    func setProgressHidden(_ isHidden: Bool) {
        
    }
    
    
}
