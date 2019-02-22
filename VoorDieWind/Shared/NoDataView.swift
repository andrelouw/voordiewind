import UIKit

class NoDataView: UIView {
    
    var view: UIView!
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var noDataTitleLabel: UILabel!
    @IBOutlet weak var noDataMessageLabel: UILabel!
    
    init() {
        super.init(frame: .zero)
        setUpView()
        
        let image = UIImage(named: "city")
        imageView.image = image
        noDataTitleLabel.text = "O ganna!"
        noDataMessageLabel.text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. "
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        super.init(frame: .zero)
        setUpView()
    }
    
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

