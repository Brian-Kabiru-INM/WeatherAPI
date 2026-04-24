//
//  SearchBar.swift
//  WeatherAPI
//
//  Created by Brian Kabiru on 20/04/2026.
//

import UIKit
import SwiftUI

/// A reusable search bar component for BlogApp
final class BlogSearchBar: UIView {
    
    // MARK: - UI Elements
    private let searchBar: UISearchBar = {
        let searchbar = UISearchBar()
        searchbar.placeholder = "Search blog posts..."
        searchbar.searchBarStyle = .minimal
        searchbar.translatesAutoresizingMaskIntoConstraints = false
        return searchbar
    }()
    
    // MARK: - Properties
    var onSearchTextChanged: ((String) -> Void)?
    var onSearchButtonClicked: ((String) -> Void)?
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        addSubview(searchBar)
        searchBar.delegate = self
        
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: trailingAnchor),
            searchBar.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

// MARK: - UISearchBarDelegate
extension BlogSearchBar: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        onSearchTextChanged?(searchText)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        if let text = searchBar.text {
            onSearchButtonClicked?(text)
        }
    }
}
import SwiftUI

struct BlogSearchBarPreview: UIViewRepresentable {
    func makeUIView(context: Context) -> BlogSearchBar {
        let searchBar = BlogSearchBar()
        searchBar.onSearchTextChanged = { text in
            print("Live typing: \(text)")
        }
        searchBar.onSearchButtonClicked = { text in
            print("Search triggered for: \(text)")
        }
        return searchBar
    }
    
    func updateUIView(_ uiView: BlogSearchBar, context: Context) {}
}

struct BlogSearchBarPreview_Previews: PreviewProvider {
    static var previews: some View {
        BlogSearchBarPreview()
            .frame(height: 50)
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
