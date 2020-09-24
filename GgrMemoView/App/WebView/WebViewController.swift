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
        self.setLayoutFullScreenWebView(webView: webView, view: view)

        webView.navigationDelegate = self

        

        
        let request = URLRequest(url: url)
        webView.load(request)
    }
    
    /// WebView読み込み時にエラーが発生
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        let alert: UIAlertController = UIAlertController(title: "インターネットに接続できません", message: nil, preferredStyle:  UIAlertController.Style.alert)
        let defaultAction: UIAlertAction = UIAlertAction(title: "閉じる", style: UIAlertAction.Style.default, handler:{
            // ボタンが押された時の処理を書く（クロージャ実装）
            (action: UIAlertAction!) -> Void in
            self.dismiss(animated: true, completion: nil)
        })
        alert.addAction(defaultAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    func setLayoutFullScreenWebView(webView: WKWebView, view: UIView) {

            // AutoLayout設定
            webView.translatesAutoresizingMaskIntoConstraints = false

            // webViewの幅をviewに合わせる
            view.addConstraints([NSLayoutConstraint(item:webView, attribute:NSLayoutConstraint.Attribute.width, relatedBy:NSLayoutConstraint.Relation.equal, toItem:view, attribute:NSLayoutConstraint.Attribute.width, multiplier:1.0, constant:0)])
            // webViewの高さをviewに合わせる
            view.addConstraints([NSLayoutConstraint(item:webView, attribute:NSLayoutConstraint.Attribute.height, relatedBy:NSLayoutConstraint.Relation.equal, toItem:view, attribute:NSLayoutConstraint.Attribute.height, multiplier:1.0, constant:0)])
        }
    
}
