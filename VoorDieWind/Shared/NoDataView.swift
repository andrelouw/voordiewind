import UIKit

class NoDataView: UIView {
    
    var view: UIView!
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var noDataTitleLabel: UILabel!
    @IBOutlet weak var noDataMessageLabel: UILabel!
    @IBOutlet weak var noDataButton: UIButton!
    
    typealias buttonHandlerType = () -> Void
    var buttonHanlder: buttonHandlerType?
    
    init(with title: String,
         message: String?,
         image: UIImage,
         buttonTitle: String?,
         shouldShowButton: Bool = true,
         buttonHandler: buttonHandlerType? = nil) {
       
        super.init(frame: .zero)
        setUpView()
        
        imageView.image = image
        noDataTitleLabel.text = title
        noDataMessageLabel.text = message
        noDataButton.setTitle(buttonTitle, for: .normal)
        noDataButton.isHidden = !shouldShowButton
        self.buttonHanlder = buttonHandler
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        super.init(frame: .zero)
        setUpView()
    }
}

// MARK: - View setup
extension NoDataView {
    private func setUpView() {
        view = loadViewFromNib()
        view.frame = bounds
        
        addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.constrainEdges(to: self)
    }
    
    private func loadViewFromNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: String(describing: NoDataView.self), bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil).first as! UIView
        
        return view
    }
}

// MARK: - Button handler
extension NoDataView {
    @IBAction func noDataButtonTapped(_ sender: Any) {
        if let completion = buttonHanlder {
            completion()
        }
    }
}

