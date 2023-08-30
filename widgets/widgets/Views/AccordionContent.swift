import UIKit

final class AccordionContent: UITableViewCell {
    var widgets: [Widget] = []
    var category: String = "Highlight"
    var height: CGFloat = 200
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 70, height: 70)
        var collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        
        return collectionView
    }()

    var heightConstraint: NSLayoutConstraint? = nil
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    init(widgets: [Widget], category: String) {
        super.init(style: .default, reuseIdentifier: nil)
        
        self.widgets = widgets
        self.category = category
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        
        contentView.addSubview(collectionView)
        collectionView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20).isActive = true
    }
        
    override func layoutSubviews() {
        super.layoutSubviews()
        print("\(category) : \( widgets.filter { $0.group == category && $0.hide == false  }.count)")
        if  widgets.filter({ $0.group == category && $0.hide == false  }).isEmpty {
            height = 0
        }
        collectionView.heightAnchor.constraint(equalToConstant: height).isActive = true
    }
}

extension AccordionContent: UICollectionViewDelegate, UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return widgets.filter { $0.group == category && $0.hide == false  }.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let widget = widgets.filter({ $0.group == category && $0.hide == false  })[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        
        // Remove subviews from cell to avoid duplication
        cell.subviews.forEach({ $0.removeFromSuperview() })
        
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: cell.frame.size.width, height: cell.frame.size.height - 30))
        imageView.contentMode = .scaleAspectFit
        cell.addSubview(imageView)

        let titleLabel = UILabel(frame: CGRect(x: 0, y: cell.frame.size.height - 30, width: cell.frame.size.width, height: 30))
        titleLabel.textColor = .black
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.systemFont(ofSize: 12)
        cell.addSubview(titleLabel)
        
        if let imageUrl = URL(string: widget.image) {
            DispatchQueue.global().async {
                if let imageData = try? Data(contentsOf: imageUrl) {
                    DispatchQueue.main.async {
                        imageView.image = UIImage(data: imageData)
                    }
                }
            }
        }

        if let title = widget.title["id"] {
            titleLabel.text = title
        }

        // add tap gesture recognizer to the cell
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapCell(sender:)))
        cell.addGestureRecognizer(tapGestureRecognizer)
        cell.tag = indexPath.row
        
        return cell
    }
    
    @objc func didTapCell(sender: UITapGestureRecognizer) {
        guard let cell = sender.view as? UICollectionViewCell else {
            return
        }
        let indexAt = cell.tag
        let widget = widgets.filter({ $0.group == category })[indexAt]
        print(widget.url)
    }
}

