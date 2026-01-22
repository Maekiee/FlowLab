import SwiftUI
import WebKit

struct CommonWebView: UIViewRepresentable {
    let url: URL
    
    func makeUIView(context: Context) -> WKWebView {
        let preferences = WKWebpagePreferences()
        preferences.allowsContentJavaScript = true
        
        let config = WKWebViewConfiguration()
        config.defaultWebpagePreferences = preferences
        
        let webView = WKWebView(frame: .zero, configuration: config)
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        // 중복 로드 방지 로직 등을 추가할 수 있음
        if uiView.url != url {
            let request = URLRequest(url: url)
            uiView.load(request)
        }
    }
    
}
