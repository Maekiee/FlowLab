import SwiftUI
import WebKit

struct CommonWebView: UIViewRepresentable {
    let url: URL
    
    func makeUIView(context: Context) -> WKWebView {
        let preferences = WKWebpagePreferences()
        let config = WKWebViewConfiguration() // 웹뷰 기본 설정
        
        preferences.allowsContentJavaScript = true // 자바스크립트 싱행 허용
        config.defaultWebpagePreferences = preferences
        
        let webView = WKWebView(frame: .zero, configuration: config)
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        if uiView.url != url {
            var request = URLRequest(url: url)
            request.setValue(AppConfig.SeSACKey, forHTTPHeaderField: "SeSACKey")
            uiView.load(request)
        }
    }
    
}
