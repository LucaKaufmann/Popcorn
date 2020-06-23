//
//  AboutViewController.swift
//  Popcorn
//
//  Created by Luca Kaufmann on 28.5.2020.
//  Copyright © 2020 mqtthings. All rights reserved.
//

import UIKit
import MarkdownView

class MarkdownViewController: UIViewController {

    let markDownView: MarkdownView = {
        let view = MarkdownView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        markDownView.onRendered = { [weak self] height in
          self?.view.setNeedsLayout()
        }
        view.addSubview(markDownView)
        // Do any additional setup after loading the view.
        setupConstraints()
        loadMarkdown()
    }
    
    private func loadMarkdown() {
        markDownView.load(markdown: "# Hello World! sdmfjhlaksdjfl;kasjdf;askldjf;askdjf; /n kdfj;slakdfjlas;dkfjsd;f /n asdfjasdfasdf")
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


struct AboutView: UIViewRepresentable {
    
    func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<AboutView>) {
        
    }
    
    func makeUIView(context: Context) -> UIView {
        return MarkdownViewController().view
    }
}

// MARK: Live preview
#if DEBUG
import SwiftUI

@available(iOS 13.0, *)
struct AboutPreview: PreviewProvider {
    static var previews: some View {
        AboutView()
    }
}

#endif

