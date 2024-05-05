//
//  TitlePreviewViewController.swift
//  Netflix Clone
//
//  Created by Nisa Aydin on 24.03.2024.
//

import UIKit
import WebKit

class TitlePreviewViewController: UIViewController {
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints=false
        label.font = .systemFont(ofSize: 22, weight: .bold)
        label.numberOfLines=0
        return label
    }()
    
    private let webView: WKWebView = {
        // WKWebView uygulamaya internetteki içerikleri yansıtmayı sağlayan bir penceredir.
        let webView = WKWebView()
        webView.translatesAutoresizingMaskIntoConstraints=false
        return webView
        
    }()
    private let overviewLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints=false
        label.numberOfLines=0
        label.font = .systemFont(ofSize: 18, weight: .regular)
       
        return label
        
    }()
    private let downloadButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .red
        button.setTitleColor(.white, for: .normal)
        button.setTitle("Download", for: .normal)
        button.layer.cornerRadius = 5
        button.layer.masksToBounds=true
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(webView)
        view.addSubview(titleLabel)
        view.addSubview(overviewLabel)
        view.addSubview(downloadButton)
        applyConstraints()
        

    }

    private func applyConstraints(){
        let webViewConstraints = [
            webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.heightAnchor.constraint(equalToConstant: 300),
        
        ]
        let titleLabelConstraints = [
            titleLabel.topAnchor.constraint(equalTo: webView.bottomAnchor, constant: 40),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
            
        ]
        let overviewLabelConstraints = [
            overviewLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 30),
            overviewLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            overviewLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
            
        ]
        let downloadButtonConstraints = [
            downloadButton.topAnchor.constraint(equalTo: overviewLabel.bottomAnchor, constant: 25),
            downloadButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            downloadButton.widthAnchor.constraint(equalToConstant: 140)
            
        ]
        
        NSLayoutConstraint.activate(webViewConstraints)
        NSLayoutConstraint.activate(titleLabelConstraints)
        NSLayoutConstraint.activate(overviewLabelConstraints)
        NSLayoutConstraint.activate(downloadButtonConstraints)
    }
    
    func configure(with model: TitlePreviewViewModel){
        titleLabel.text = model.title
        overviewLabel.text = model.titleOverview
        
        guard let url = URL(string: "https://www.youtube.com/embed/\(model.youtubeView.id.videoId)") else {
            return
        }
        webView.load(URLRequest(url: url))
    }

}
