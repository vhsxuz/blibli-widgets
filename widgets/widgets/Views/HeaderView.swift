import UIKit

protocol HeaderViewDelegate {
    func buttonDidTapped(sender: UIButton)
}

final class HeaderView: UIView {
    
    static var allInstances = [HeaderView]()
    let button: UIButton = UIButton()
    var buttonLabel: UILabel = UILabel()
    var image: UIImage = UIImage(systemName: "chevron.up") ?? UIImage()
    var imageView: UIImageView!
    var isAccordionExpanded = false
    var delegate: HeaderViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(tag: Int, expanded isExpanded: Bool) {
        super.init(frame: .zero)
        button.tag = tag
        self.image = (isExpanded ? UIImage(systemName: "chevron.down") : UIImage(systemName: "chevron.up")) ?? UIImage()
        
        setupView()
        
        HeaderView.allInstances.append(self)
    }
    
    func setValue(buttonName: String) {
        buttonLabel.text = buttonName
    }
    
    func setupView() {
        addSubview(button)
        button.backgroundColor = .white
        button.setTitleColor(.black, for: .normal)
        button.contentHorizontalAlignment = .left
        
        // Add label to the button's content view
        button.addSubview(buttonLabel)
        buttonLabel.translatesAutoresizingMaskIntoConstraints = false
        buttonLabel.leadingAnchor.constraint(equalTo: button.leadingAnchor, constant: 40).isActive = true
        buttonLabel.topAnchor.constraint(equalTo: button.topAnchor).isActive = true
        buttonLabel.bottomAnchor.constraint(equalTo: button.bottomAnchor).isActive = true
        
        // Initialize imageView here instead
        imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        button.addSubview(imageView)
        imageView.trailingAnchor.constraint(equalTo: button.trailingAnchor, constant: -40).isActive = true
        imageView.centerYAnchor.constraint(equalTo: button.centerYAnchor).isActive = true
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0).isActive = true
        button.topAnchor.constraint(equalTo: topAnchor).isActive = true
        button.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        button.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        button.addTarget(self, action: #selector(buttonDidTapped), for: .touchUpInside)
    }
    
    @objc func buttonDidTapped() {
        isAccordionExpanded.toggle()
        let image = isAccordionExpanded ? UIImage(systemName: "chevron.down") : UIImage(systemName: "chevron.up")
        
        // Update all other instances
        for instance in HeaderView.allInstances where instance != self {
            instance.isAccordionExpanded = false
            instance.imageView.image = UIImage(systemName: "chevron.up")
        }
        
        imageView.image = image
        delegate?.buttonDidTapped(sender: button)
    }
}
