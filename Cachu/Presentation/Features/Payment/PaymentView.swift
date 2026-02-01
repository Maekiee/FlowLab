import SwiftUI
import WebKit
import Combine
import iamport_ios

struct PaymentView: View {
    let totalPrice: Int
    let onFinish: (IamportResponse?) -> Void
    let onDismiss: () -> Void

    @State private var isWebViewLoading = true

    var body: some View {
        NavigationStack {
            ZStack {
                PaymentWebViewContainer(
                    totalPrice: totalPrice,
                    isLoading: $isWebViewLoading,
                    onFinish: onFinish
                )
                .opacity(isWebViewLoading ? 0 : 1)

                if isWebViewLoading {
                    VStack(spacing: 16) {
                        ProgressView()
                            .controlSize(.large)

                        Text("결제 화면을 불러오는 중...")
                            .font(.system(size: 15))
                            .foregroundStyle(.secondary)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color(.systemBackground))
                }
            }
            .navigationTitle("결제")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        Iamport.shared.close()
                        onDismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .foregroundStyle(.primary)
                    }
                }
            }
        }
    }
}

// MARK: - UIViewControllerRepresentable

private struct PaymentWebViewContainer: UIViewControllerRepresentable {
    let totalPrice: Int
    @Binding var isLoading: Bool
    let onFinish: (IamportResponse?) -> Void

    func makeUIViewController(context: Context) -> PaymentWebViewController {
        let vc = PaymentWebViewController()
        vc.totalPrice = totalPrice
        vc.onFinish = onFinish
        vc.onLoadingChanged = { [self] loading in
            isLoading = loading
        }
        return vc
    }

    func updateUIViewController(_ uiViewController: PaymentWebViewController, context: Context) {}
}

// MARK: - Payment UIViewController

private final class PaymentWebViewController: UIViewController {
    var totalPrice = 0
    var onFinish: ((IamportResponse?) -> Void)?
    var onLoadingChanged: ((Bool) -> Void)?

    private var isPaymentRequested = false
    private var loadingObservation: NSKeyValueObservation?

    private lazy var wkWebView: WKWebView = {
        let webView = WKWebView()
        webView.backgroundColor = .clear
        return webView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        attachWebView()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        guard !isPaymentRequested else { return }
        isPaymentRequested = true
        observeWebViewLoading()
        requestPayment()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        loadingObservation?.invalidate()
        loadingObservation = nil
    }

    private func attachWebView() {
        view.addSubview(wkWebView)
        wkWebView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            wkWebView.topAnchor.constraint(equalTo: view.topAnchor),
            wkWebView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            wkWebView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            wkWebView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }

    private func observeWebViewLoading() {
        loadingObservation = wkWebView.observe(\.isLoading, options: [.new]) { [weak self] _, change in
            guard let isLoading = change.newValue else { return }
            DispatchQueue.main.async {
                if !isLoading {
                    self?.onLoadingChanged?(false)
                }
            }
        }
    }

    private func requestPayment() {
        let payment = IamportPayment(
            pg: PG.html5_inicis.makePgRawName(pgId: "INIpayTest"),
            merchant_uid: "mid_\(Int(Date().timeIntervalSince1970 * 1000))",
            amount: "\(totalPrice)"
        )
        payment.pay_method = PayMethod.card.rawValue
        payment.name = "부동산 예약금"
        payment.app_scheme = "cachu"

        let userCode = "imp14511373"

        Iamport.shared.useNavigationButton(enable: false)
        Iamport.shared.paymentWebView(
            webViewMode: wkWebView,
            userCode: userCode,
            payment: payment
        ) { [weak self] response in
            self?.onFinish?(response)
        }
    }
}
