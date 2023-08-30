import UIKit

protocol SearchBarDelegate: AnyObject {
    func didUpdateDataItems(_ dataItems: [DataItem], textSearch: String)
}

final class SearchBar: UIView {
    
    let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.placeholder = "Search"
        searchBar.searchBarStyle = .minimal
        searchBar.tintColor = .black
        searchBar.barTintColor = .white
        searchBar.backgroundImage = UIImage()
        searchBar.showsCancelButton = false
        return searchBar 
    }()
    
    var dataItems: [DataItem] = []
    weak var delegate: SearchBarDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // Add subview
        addSubview(searchBar)
        
        // Search Bar Constraints
        searchBar.topAnchor.constraint(equalTo: topAnchor, constant: 8).isActive = true
        searchBar.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8).isActive = true
        searchBar.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8).isActive = true
        searchBar.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8).isActive = true
        
        searchBar.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        searchBar.delegate = self
    }
}

extension SearchBar: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text else { return }
        
        // Perform the search using the searchText
        
        // For example, print the search text to the console
        print("Search Text: \(searchText)")
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        // Handle cancel button click
        
        // Clear the search text from the search bar
        searchBar.text = nil
        
        // Dismiss the keyboard
        searchBar.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let widgetsCount = dataItems.count
        print(searchText)
        if searchText == "" {
            print("empty")
            for index in 0...widgetsCount - 1 {
                let componentsCount = dataItems[index].widgets.count
                for indexes in 0...componentsCount - 1 {
                    dataItems[index].widgets[indexes].hide = false
                }
            }
        }
        else {
            for index in 0...widgetsCount - 1 {
                let componentsCount = dataItems[index].widgets.count
                for indexs in 0...componentsCount - 1 {
                    if let title = dataItems[index].widgets[indexs].title["id"],
                       title.lowercased().contains(searchText.lowercased()) {
                        dataItems[index].widgets[indexs].hide = false
                    }
                    else {
                        dataItems[index].widgets[indexs].hide = true
                    }
                }
            }
        }
        delegate?.didUpdateDataItems(dataItems, textSearch: searchText)
    }
}
