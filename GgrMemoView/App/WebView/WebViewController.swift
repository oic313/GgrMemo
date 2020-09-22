import UIKit
import WebKit

final class WebViewController: UIViewController, WKNavigationDelegate {
        
    private var webView: WKWebView = WKWebView()
    private let url: URL

    public init(url: URL) {
        self.url = url
        super.init(nibName: nil, bundle: Bundle(for: Self.self))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // WKWebViewの追加
        webView = WKWebView(frame:CGRect(x: 0, y: 0, width: view.bounds.size.width, height: view.bounds.size.height))
        view.addSubview(webView)
        
        webView.navigationDelegate = self

        

        
        let request = URLRequest(url: url)
        webView.load(request)
    }
    
    /// WebView読み込み時にエラーが発生
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        // ここに処理を書く！
    }
    
}
