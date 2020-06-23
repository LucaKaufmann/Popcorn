//
//  AboutViewController.swift
//  Popcorn
//
//  Created by Luca Kaufmann on 28.5.2020.
//  Copyright © 2020 mqtthings. All rights reserved.
//

import UIKit
import MarkdownView
import SwiftUI

class MarkdownViewController: UIViewController {
    
    var aboutUrl: String = ""
    
    let markDownView: MarkdownView = {
        let view = MarkdownView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        
        return view
    }()
    
    convenience init(aboutUrl: String) {
        self.init()
        self.aboutUrl = aboutUrl
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        markDownView.onRendered = { [weak self] height in
          self?.view.setNeedsLayout()
        }
        
        markDownView.onTouchLink = { [weak self] request in
          guard let url = request.url else { return false }

          if url.scheme == "file" {
            return false
          } else if url.scheme == "https" {
            UIApplication.shared.open(url)
            return false
          } else {
            return false
          }
        }
        view.addSubview(markDownView)
        // Do any additional setup after loading the view.
        setupConstraints()
        loadMarkdown()
    }
    
    private func loadMarkdown() {
        let session = URLSession(configuration: .default)
        let url = URL(string: aboutUrl)!
        let task = session.dataTask(with: url) {data, _, _ in
          let str = String(data: data!, encoding: String.Encoding.utf8)
          DispatchQueue.main.async {
            self.markDownView.load(markdown: str)
          }
        }
        task.resume()
//        markDownView.load(markdown: "# Valorant Setups\n\nValorant Setups contains open-source components:\n* MarkdownView")
    }

    func setupConstraints() {
        let markdownViewConstraints = [
            markDownView.topAnchor.constraint(equalTo: view.topAnchor),
            markDownView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            markDownView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            markDownView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ]
        
        NSLayoutConstraint.activate(markdownViewConstraints)
    }

}


struct MarkdownWrapperView: UIViewRepresentable {
    
    var aboutUrl: String
    
    func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<MarkdownWrapperView>) {
        
    }
    
    func makeUIView(context: Context) -> UIView {
        return MarkdownViewController(aboutUrl: aboutUrl).view
    }
}

// MARK: Live preview
#if DEBUG
import SwiftUI

@available(iOS 13.0, *)
struct AboutPreview: PreviewProvider {
    static var previews: some View {
        MarkdownWrapperView(aboutUrl: "https://github.com/LucaKaufmann/video-data/blob/master/about.md")
    }
}

#endif

