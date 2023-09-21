//
//  TranslationWebViewController.swift
//  iOSCore
//
//  Created by Jaewon Yun on 2023/09/21.
//  Copyright © 2023 woin2ee. All rights reserved.
//

import Domain
import UIKit
import WebKit

final class TranslationWebViewController: UIViewController {

    let webView: WKWebView = .init()

    var translationSite: TranslationSite

    var word: String = ""

    init(translationSite: TranslationSite) {
        self.translationSite = translationSite
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        self.view = webView
    }

    func loadWebView() throws {
        let url: String = translationSite.url(forWord: word)

        guard
            let encodedURL = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
            let requestURL: URL = .init(string: encodedURL)
        else {
            throw TranslationWebViewError.notValidURL
        }

        let request: URLRequest = .init(url: requestURL)
        webView.load(request)
    }

}

extension TranslationWebViewController {

    enum TranslationWebViewError: Error {

        case notValidURL

    }

}
