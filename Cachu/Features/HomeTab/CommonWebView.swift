import SwiftUI
import WebKit

struct CommonWebView: UIViewRepresentable {
    let url: URL
    let accessToken: String
    var onAttendanceComplete: ((Int) -> Void)?

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIView(context: Context) -> WKWebView {
        let preferences = WKWebpagePreferences()
        preferences.allowsContentJavaScript = true

        let config = WKWebViewConfiguration()
        config.defaultWebpagePreferences = preferences

        let contentController = WKUserContentController()
        contentController.add(context.coordinator, name: "click_attendance_button")
        contentController.add(context.coordinator, name: "complete_attendance")
        config.userContentController = contentController

        let webView = WKWebView(frame: .zero, configuration: config)
        context.coordinator.webView = webView
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        if uiView.url != url {
            var request = URLRequest(url: url)
            request.setValue(AppConfig.SeSACKey, forHTTPHeaderField: "SeSACKey")
            uiView.load(request)
        }
    }

    static func dismantleUIView(_ uiView: WKWebView, coordinator: Coordinator) {
        uiView.configuration.userContentController.removeScriptMessageHandler(forName: "click_attendance_button")
        uiView.configuration.userContentController.removeScriptMessageHandler(forName: "complete_attendance")
    }

    // MARK: - Coordinator
    final class Coordinator: NSObject, WKScriptMessageHandler {
        private let parent: CommonWebView
        weak var webView: WKWebView?

        init(_ parent: CommonWebView) {
            self.parent = parent
        }

        func userContentController(
            _ userContentController: WKUserContentController,
            didReceive message: WKScriptMessage
        ) {
            switch message.name {
            case "click_attendance_button":
                // 출석 버튼 클릭 → 액세스 토큰 전달
                webView?.evaluateJavaScript("requestAttendance('\(parent.accessToken)')")

            case "complete_attendance":
                // 출석 완료 → 출석 횟수 전달
                if let count = message.body as? Int {
                    parent.onAttendanceComplete?(count)
                }

            default:
                break
            }
        }
    }
}
