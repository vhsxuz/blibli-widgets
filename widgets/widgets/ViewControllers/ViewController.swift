import UIKit

class ViewController: UIViewController {
    let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    var selectedSection = -1
    let titleLabel = TitleLabel()
    let searchBar = SearchBar()
    let highlightLabel = TitleLabel()
    let highlightCollectionView = CollectionView()
    lazy var highlightCollectionViewHeight = highlightCollectionView.heightAnchor.constraint(equalToConstant: 0)
    lazy var highlightLabelViewHeight = highlightLabel.heightAnchor.constraint(equalToConstant: 0)
    var appManager = AppManager()
    var dataItems: [DataItem] = []
    var searchText = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        appManager.delegate = self
        appManager.get()
        
        searchBar.delegate = self
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "titleCell")
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "searchBarCell")
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "collectionViewCell")
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "accordionCell")
        view.addSubview(tableView)
        
        setupLayout()
    }
    
    func generateTitleLabel(cell: UITableViewCell) {
        cell.contentView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.topAnchor.constraint(equalTo: cell.contentView.topAnchor, constant: 10).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: 40).isActive = true
        titleLabel.widthAnchor.constraint(equalTo: cell.contentView.safeAreaLayoutGuide.widthAnchor).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
    
    func generateSearchBar(cell: UITableViewCell) {
        searchBar.dataItems = dataItems
        cell.contentView.addSubview(searchBar)
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.topAnchor.constraint(equalTo: cell.contentView.topAnchor).isActive = true
        searchBar.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor).isActive = true
        searchBar.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: 20).isActive = true
        searchBar.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -20).isActive = true
    }
    
    func generateHighlightTitle(cell: UITableViewCell) {
        highlightLabel.titleLabel.text = "Highlight"
        cell.contentView.addSubview(highlightLabel)
        highlightLabel.translatesAutoresizingMaskIntoConstraints = false
        highlightLabel.topAnchor.constraint(equalTo: cell.contentView.topAnchor, constant: 10).isActive = true
        highlightLabel.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: 25).isActive = true
        highlightLabel.widthAnchor.constraint(equalTo: cell.contentView.safeAreaLayoutGuide.widthAnchor).isActive = true
        
        var height: CGFloat = 40
        if isFilteredWidgetEmpty(section: 3) {
            height = 0
        }
        highlightLabelViewHeight.constant = height
        highlightLabelViewHeight.isActive = true
    }
    
    func generateHighlightCollectionView(cell: UITableViewCell) {
        highlightCollectionView.removeFromSuperview()
        cell.contentView.addSubview(highlightCollectionView)
        cell.contentView.bringSubviewToFront(highlightCollectionView)
        highlightCollectionView.widgets = dataItems[0].widgets
        //        highlightCollectionView.layoutIfNeeded()
        highlightCollectionView.translatesAutoresizingMaskIntoConstraints = false
        highlightCollectionView.topAnchor.constraint(equalTo: cell.contentView.topAnchor, constant: 10).isActive = true
        highlightCollectionView.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor).isActive = true
        highlightCollectionView.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: 20).isActive = true
        highlightCollectionView.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -20).isActive = true
        
        var height: CGFloat = 320
        if isFilteredWidgetEmpty(section: 3) {
            height = 0
        }
        highlightCollectionViewHeight.constant = height
        highlightCollectionViewHeight.isActive = true
        
    }
    
    func isFilteredWidgetEmpty(section: Int) -> Bool {
        let widgets = dataItems[section - 4 + 1].widgets
        let filteredWidgets = widgets.filter { widget in
            return widget.hide == false
        }
        return filteredWidgets.isEmpty
    }
    
    func setupLayout() {
        // Project Base
        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        tableView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor).isActive = true
        tableView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor).isActive = true
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if !searchText.isEmpty {
            return 1
        }
        if (section < 4) {
            return 1
        }
        else if selectedSection == section {
            return 1
        }
        return 0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataItems.count + 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cellId = ""
        if(indexPath.row == 0) {
            cellId = "titleCell"
        }
        else if(indexPath.row == 1) {
            cellId = "searchBarCell"
        }
        else if(indexPath.row == 2) {
            cellId = "titleCell"
        }
        else if(indexPath.row == 3) {
            cellId = "collectionViewCell"
        }
        else {
            cellId = "accordionCell"
        }
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellId) else {
            return UITableViewCell()
        }
        cell.selectionStyle = .none
        if(indexPath.section == 0) {
            generateTitleLabel(cell: cell)
        }
        else if(indexPath.section == 1) {
            generateSearchBar(cell: cell)
        }
        else if(indexPath.section == 2) {
            if dataItems.count > 0 {
                generateHighlightTitle(cell: cell)
            }
        }
        else if(indexPath.section == 3) {
            if dataItems.count > 0 {
                generateHighlightCollectionView(cell: cell)
            }
        }
        else {
            if(dataItems.count > 0) {
                if(indexPath.section >= 4) {
                    let cell = AccordionContent()
                    cell.widgets = dataItems[indexPath.section - 4 + 1].widgets
                    cell.category = dataItems[indexPath.section - 4 + 1].group
                    cell.layoutIfNeeded()
                    return cell
                }
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard section >= 4 else { return nil }
        
        if isFilteredWidgetEmpty(section: section) {
            return nil
        }
        
        var isExpanded = false
        if(!searchText.isEmpty || selectedSection == section) {
            isExpanded = true
        }
        let sectionButton = HeaderView(tag: section, expanded: isExpanded)
        sectionButton.isUserInteractionEnabled = searchText.isEmpty
        sectionButton.setValue(buttonName: dataItems[section - 4 + 1].group)
        sectionButton.delegate = self
        
        return sectionButton
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if(section < 4) {
            return CGFLOAT_MIN
        }
        else {
            
            if isFilteredWidgetEmpty(section: section) {
                return CGFLOAT_MIN
            }
            else {
                return 40
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFLOAT_MIN
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        guard indexPath.section != 2, dataItems.count <= 0, !isFilteredWidgetEmpty(section: 3) else {
//            return 0
//        }
        if indexPath.section == 2, dataItems.count > 0, isFilteredWidgetEmpty(section: 3) {
            return 0
        }
        return UITableView.automaticDimension
        
    }
    
}

extension ViewController: AppManagerDelegate {
    func didUpdateApp(_ appManager: AppManager, dataItems: [DataItem]) {
        self.dataItems = dataItems
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
}

extension ViewController: HeaderViewDelegate {
    func buttonDidTapped(sender: UIButton) {
        //        sender.accordionButtonTapped()
        let section = sender.tag
        
        func indexPathsForSection(at section: Int = section) -> [IndexPath] {
            var indexPaths = [IndexPath]()
            indexPaths.append(IndexPath(row: 0, section: section))
            
            return indexPaths
        }
        
        // kalau -1 artinya belum ada yang dibuka
        if self.selectedSection == -1 {
            self.selectedSection = section
            self.tableView.insertRows(at: indexPathsForSection(),
                                      with: .fade)
        } else if(selectedSection == section) {
            self.selectedSection = -1
            self.tableView.deleteRows(at: indexPathsForSection(),
                                      with: .fade)
        } else {
            tableView.performBatchUpdates { // ngejalanin biar bareng pas delete dan insert
                self.tableView.deleteRows(at: indexPathsForSection(at: self.selectedSection),
                                          with: .fade)
                self.selectedSection = section
                self.tableView.insertRows(at: indexPathsForSection(),
                                          with: .fade)
            }
        }
    }
}

extension ViewController: SearchBarDelegate {
    func didUpdateDataItems(_ dataItems: [DataItem], textSearch: String) {
        self.dataItems = dataItems
        //        highlightCollectionView.widgets = dataItems[0].widgets
        searchText = textSearch
        DispatchQueue.main.async {
            let indexSet = IndexSet(2..<self.tableView.numberOfSections)
            self.tableView.performBatchUpdates {
                self.tableView.reloadSections(indexSet, with: .fade)
            }
        }
    }
}
