import UIKit

class ReferralCodeViewController: UIViewController, Storyboarded {
	var coordinator: MainCoordinator?

	// MARK: - Properties
	@IBOutlet private weak var label: UILabel!
	@IBOutlet private weak var label2: UILabel!
	@IBOutlet private weak var label3: UILabel!
	@IBOutlet private weak var rectangle1View: UIView!
	@IBOutlet private weak var rectangle1View2: UIView!
	@IBOutlet private weak var rectangle1View3: UIView!
	@IBOutlet private weak var rectangle1View4: UIView!
	@IBOutlet private weak var rectangle1View5: UIView!
	@IBOutlet private weak var clickHereIfYoureStuckLabel: UILabel!
	@IBOutlet private weak var rectangle5View: UIView!
	@IBOutlet private weak var enterLabel: UILabel!

	override func viewDidLoad() {
		super.viewDidLoad()
		setupViews()
		setupLayout()
	}

}

extension ReferralCodeViewController {
	private func setupViews() {

		label.textColor = UIColor.daisy
		label.numberOfLines = 0
		label.font = UIFont.textStyle14
		label.textAlignment = .left
		label.text = NSLocalizedString("string.name4", comment: "")

		label2.textColor = UIColor.daisy
		label2.numberOfLines = 0
		label2.font = UIFont.textStyle14
		label2.textAlignment = .left
		label2.text = NSLocalizedString("string.name4", comment: "")

		label3.textColor = UIColor.daisy
		label3.numberOfLines = 0
		label3.font = UIFont.textStyle14
		label3.textAlignment = .left
		label3.text = NSLocalizedString("string.name4", comment: "")

		rectangle1View.backgroundColor = UIColor.daisy


		rectangle1View2.backgroundColor = UIColor.daisy


		rectangle1View3.backgroundColor = UIColor.daisy


		rectangle1View4.backgroundColor = UIColor.daisy


		rectangle1View5.backgroundColor = UIColor.daisy


		clickHereIfYoureStuckLabel.textColor = UIColor.daisy
		clickHereIfYoureStuckLabel.numberOfLines = 0
		clickHereIfYoureStuckLabel.font = UIFont.textStyle10
		clickHereIfYoureStuckLabel.textAlignment = .center
		clickHereIfYoureStuckLabel.text = NSLocalizedString("click.here.if.youre.stuck", comment: "")

		rectangle5View.layer.cornerRadius = 27
		rectangle5View.layer.masksToBounds =  true
		rectangle5View.backgroundColor = UIColor.daisy


		enterLabel.textColor = UIColor.black
		enterLabel.numberOfLines = 0
		enterLabel.font = UIFont.textStyle5
		enterLabel.textAlignment = .center
		enterLabel.text = NSLocalizedString("enter", comment: "")


	}

	private func setupLayout() {
		//Constraints are defined in Storyboard file.
	}

}
