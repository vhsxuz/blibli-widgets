import UIKit

final class AccordionView: UIView {
    weak var delegate: AccordionViewDelegate?
    
    let accordionView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    }()
    
    let accordionTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Isi Ulang"
        label.font = UIFont.boldSystemFont(ofSize: 18)
        return label
    }()
    
    let accordionButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "chevron.up"), for: .normal)
        button.tintColor = .black
        return button
    }()
    
    let accordionContentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var accordionCollectionViewHeightConstraint: NSLayoutConstraint?
    var accordionContentViewHeightConstraint: NSLayoutConstraint!
    var isAccordionExpanded = false
    var categories: String = ""
    let collectionView = CollectionView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(accordionView)
        accordionView.addSubview(accordionTitleLabel)
        accordionView.addSubview(accordionButton)
        accordionView.addSubview(accordionContentView)
        accordionContentViewHeightConstraint = accordionContentView.heightAnchor.constraint(equalToConstant: 0)
        accordionContentViewHeightConstraint.isActive = true
        accordionButton.addTarget(self, action: #selector(accordionButtonTapped), for: .touchUpInside)
        accordionContentView.addSubview(collectionView)
        setupView()
    }
    
    func updateCategories(category: String) {
        self.categories = category
        collectionView.category = categories
    }
    
    func setupView() {
        accordionView.translatesAutoresizingMaskIntoConstraints = false
        accordionTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        accordionButton.translatesAutoresizingMaskIntoConstraints = false
        accordionContentView.translatesAutoresizingMaskIntoConstraints = false
        
        // Set up constraints for accordionView
        accordionView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        accordionView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        accordionView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        accordionView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        // Set up constraints for accordionTitleLabel
        accordionTitleLabel.topAnchor.constraint(equalTo: accordionView.topAnchor).isActive = true
        accordionTitleLabel.leadingAnchor.constraint(equalTo: accordionView.leadingAnchor, constant: 20).isActive = true
        
        // Set up constraints for accordionButton
        accordionButton.topAnchor.constraint(equalTo: accordionView.topAnchor).isActive = true
        accordionButton.leadingAnchor.constraint(equalTo: accordionView.leadingAnchor, constant: 300).isActive = true
        accordionButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        accordionButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        // Set up constraints for accordionContentView
        accordionContentView.topAnchor.constraint(equalTo: accordionTitleLabel.bottomAnchor, constant: 10).isActive = true
        accordionContentView.leadingAnchor.constraint(equalTo: accordionView.leadingAnchor, constant: 20).isActive = true
        accordionContentView.trailingAnchor.constraint(equalTo: accordionView.trailingAnchor, constant: -20).isActive = true
        accordionContentView.bottomAnchor.constraint(equalTo: accordionView.bottomAnchor, constant: -20).isActive = true
        accordionContentView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.topAnchor.constraint(equalTo: accordionContentView.topAnchor).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: accordionContentView.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: accordionContentView.trailingAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: accordionContentView.bottomAnchor).isActive = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(accordionButtonTapped))
        accordionButton.addGestureRecognizer(tapGesture)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func accordionButtonTapped() {
        isAccordionExpanded.toggle()
        let image = isAccordionExpanded ? UIImage(systemName: "chevron.down") : UIImage(systemName: "chevron.up")
        accordionButton.setImage(image, for: .normal)
        
        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            guard let self = self else { return }
            if self.isAccordionExpanded {
                self.accordionContentView.isHidden = false
                self.accordionCollectionViewHeightConstraint?.isActive = false
                self.accordionContentViewHeightConstraint.constant = 150
            } else {
                self.accordionContentView.isHidden = true
                self.accordionCollectionViewHeightConstraint?.isActive = true
                self.accordionContentViewHeightConstraint.constant = 0
            }
            self.layoutIfNeeded()
        }, completion: { [weak self] _ in
            guard let self = self else { return }
            if !self.isAccordionExpanded {
                self.accordionContentView.isHidden = true
                self.accordionCollectionViewHeightConstraint?.isActive = true
            }
            else {
                self.accordionContentView.isHidden = false
                self.accordionCollectionViewHeightConstraint?.isActive = false
            }
            self.layoutIfNeeded()
            self.delegate?.accordionButtonTapped()
        })
    }
}

protocol AccordionViewDelegate: AnyObject {
    func accordionButtonTapped()
}
