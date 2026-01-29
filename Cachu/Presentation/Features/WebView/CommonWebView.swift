import SwiftUI
import WebKit

enum WebMessageName: String, CaseIterable {
    case clickAttendance = "click_attendance_button"
    case completeAttendance = "complete_attendance"
    
    func js(with token: String) -> String? {
        switch self {
        case .clickAttendance:
            return "requestAttendance('\(token)')"
        case .completeAttendance:
            return nil
        }
    }
}

struct CommonWebView: UIViewRepresentable {
    let url: URL
    let accessToken: String
    var onAttendanceComplete: ((Int) -> Void)?

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView(frame: .zero, configuration: makeConfiguration(coordinator: context.coordinator))
        context.coordinator.webView = webView
        loadInitialRequest(in: webView)
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        guard uiView.url != url else { return }
        loadInitialRequest(in: uiView)
    }

    static func dismantleUIView(_ uiView: WKWebView, coordinator: Coordinator) {
        let coordinator = uiView.configuration.userContentController
        WebMessageName.allCases.forEach {
            coordinator.removeScriptMessageHandler(forName: $0.rawValue)
        }
    }
}


// MARK: - Private Helpers
private extension CommonWebView {
    func makeConfiguration(coordinator: Coordinator) -> WKWebViewConfiguration {
        let preferences = WKWebpagePreferences()
        preferences.allowsContentJavaScript = true
        
        let config = WKWebViewConfiguration()
        config.defaultWebpagePreferences = preferences
        config.userContentController = makeContentController(coordinator: coordinator)
        
        return config
    }
    
    func makeContentController(coordinator: Coordinator) -> WKUserContentController {
        let controller = WKUserContentController()
        WebMessageName.allCases.forEach {
            controller.add(coordinator, name: $0.rawValue)
        }
        return controller
    }
    
    func loadInitialRequest(in webView: WKWebView) {
        var request = URLRequest(url: url)
        request.setValue(AppConfig.SeSACKey, forHTTPHeaderField: AppConfig.SeSACKeyName)
        webView.load(request)
    }
}

// MARK: - Coordinator
extension CommonWebView {
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
            guard let messageType = WebMessageName(rawValue: message.name) else {
                print("정의 되지 않은 메세지 타입: \(message.name)")
                return
            }
            
            handleMessage(messageType, body: message.body)
        }
        
        private func handleMessage(_ type: WebMessageName, body: Any) {
            switch type {
            case .clickAttendance:
                executeAttendanceRequest()
            case .completeAttendance:
                handleAttendanceComplete(body: body)
            }
        }
        
        private func executeAttendanceRequest() {
            guard let script = WebMessageName.clickAttendance.js(with: parent.accessToken) else {
                return
            }
            
            webView?.evaluateJavaScript(script) { result, error in
                if let error = error {
                    print("❌ 자바스크립트 실행 실패: \(error.localizedDescription)")
                }
            }
        }
        
        private func handleAttendanceComplete(body: Any) {
            guard let count = body as? Int else {
                print("⚠️ 출석 완료 데이터 파싱 실패: \(body)")
                return
            }
            
            Task { @MainActor in
                parent.onAttendanceComplete?(count)
            }
        }
    }
}
