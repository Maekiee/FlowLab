import UIKit
import iamport_ios

@MainActor
final class PaymentManager {

    private init() {}

    private static weak var loadingOverlay: UIView?

    static func requestPayment(
        totalPrice: Int,
        onFinish: @escaping (IamportResponse?) -> Void
    ) {
        guard let viewController = topViewController() else { return }

        showLoadingOverlay(on: viewController)

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
        Iamport.shared.payment(
            viewController: viewController,
            userCode: userCode,
            payment: payment
        ) { response in
            removeLoadingOverlay()
            onFinish(response)
        }
    }

    // MARK: - Loading Overlay

    private static func showLoadingOverlay(on viewController: UIViewController) {
        let overlay = UIView(frame: viewController.view.bounds)
        overlay.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        overlay.backgroundColor = UIColor.black.withAlphaComponent(0.3)

        let indicator = UIActivityIndicatorView(style: .large)
        indicator.color = .white
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.startAnimating()

        overlay.addSubview(indicator)
        NSLayoutConstraint.activate([
            indicator.centerXAnchor.constraint(equalTo: overlay.centerXAnchor),
            indicator.centerYAnchor.constraint(equalTo: overlay.centerYAnchor)
        ])

        viewController.view.addSubview(overlay)
        loadingOverlay = overlay
    }

    private static func removeLoadingOverlay() {
        loadingOverlay?.removeFromSuperview()
        loadingOverlay = nil
    }

    // MARK: - Top ViewController

    private static func topViewController() -> UIViewController? {
        guard let windowScene = UIApplication.shared.connectedScenes
            .compactMap({ $0 as? UIWindowScene }).first,
              let rootVC = windowScene.windows.first(where: { $0.isKeyWindow })?.rootViewController
        else { return nil }

        var top = rootVC
        while let presented = top.presentedViewController {
            top = presented
        }
        return top
    }
}
