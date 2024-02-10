//
//  TranslationWebViewController.swift
//  iOSCore
//
//  Created by Jaewon Yun on 2023/09/21.
//  Copyright © 2023 woin2ee. All rights reserved.
//

import Domain
import IOSSupport
import Then
import UIKit
import WebKit

public final class TranslationWebViewController: BaseViewController {

    lazy var webView: WKWebView = .init().then {
        $0.navigationDelegate = self
    }

    var translationSite: TranslationSite

    var word: String = ""

    private var activityIndicatorView: ActivityIndicatorViewController? = .init()

    init(translationSite: TranslationSite) {
        self.translationSite = translationSite
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func loadView() {
        self.view = webView
    }

    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        activityIndicatorView = nil
    }

    public func loadWebView() throws {
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

// MARK: - WKNavigationDelegate

extension TranslationWebViewController: WKNavigationDelegate {

    public func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        activityIndicatorView?.startAnimating(on: self)
    }

    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        activityIndicatorView?.stopAnimating(on: self)
    }

}
