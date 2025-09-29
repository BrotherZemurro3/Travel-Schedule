
import SwiftUI
import WebKit
// Представление WKWebView для SwiftUI
struct WebView: UIViewControllerRepresentable {
    let url: URL
    @Binding var isNetworkAvailable: Bool
    func makeUIViewController(context: Context) -> WKWebViewController {
        let controller = WKWebViewController()
        controller.url = url
        return controller
    }
    
    
    func updateUIViewController(_ uiViewController: WKWebViewController, context: Context) {
        // Обновление не требуется, так как URL задается один раз
    }
}

// Контроллер для WKWebView
class WKWebViewController: UIViewController {
    var url: URL?
    private var webView: WKWebView!
    
    var netWorkStatusHandler: ((Bool) -> Void)?
    
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "NetworkMonitor")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView = WKWebView(frame: view.bounds)
        webView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        webView.navigationDelegate = self
        startNetworkMonitoring()
        view.addSubview(webView)
        
        if let url = url {
            let request = URLRequest(url: url)
            webView.load(request)
        }
        
        // Добавляем обработчик события, чтобы вставить CSS после загрузки страницы
        webView.navigationDelegate = self
    }
    
    private func startNetworkMonitoring() {
        monitor.pathUpdateHandler = { [weak self] path in
            guard let self = self else {return}
            if path.status == .satisfied {
                self.netWorkStatusHandler?(true)
                
                // Если есть сеть и URL - грузим страницу
                
                if let url = self.url {
                    DispatchQueue.main.async {
                        let request = URLRequest(url: url)
                        self.webView.load(request)
                        
                    }
                }
            } else {
                self.netWorkStatusHandler?(false)
            }
        }
        monitor.start(queue: queue)
        }
    deinit {
        monitor.cancel()
    }
}

extension WKWebViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        // CSS для тёмной темы
        let darkModeCSS = """
            @media (prefers-color-scheme: dark) {
                body {
                    background-color: #181A20 !important;
                    color: white !important;
                }
                a {
                    color: #bb86fc !important;
                }
            }
        """
        
        // JavaScript для вставки стилей
        let js = """
            var style = document.createElement('style');
            style.innerHTML = `\(darkModeCSS)`;
            document.head.appendChild(style);
        """
        
        webView.evaluateJavaScript(js, completionHandler: nil)
    }
}
