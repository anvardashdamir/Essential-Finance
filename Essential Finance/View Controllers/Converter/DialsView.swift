//
//  DialsView.swift
//  Essential Finance
//
//  Created by Enver's Macbook Pro on 11/20/24.
//

import UIKit

class DialsView: UIView {
    
    weak var delegate: DialsViewDelegate?
    
    // Keypads
    private var one: UIImageView!
    private var two: UIImageView!
    private var three: UIImageView!
    private var four: UIImageView!
    private var five: UIImageView!
    private var six: UIImageView!
    private var seven: UIImageView!
    private var eight: UIImageView!
    private var nine: UIImageView!
    private var zero: UIImageView!
    private var clear: UIImageView!
    private var backspace: UIImageView!
    
    // StackViews for rows
    private let row1 = DialsView.createHorizontalStack()
    private let row2 = DialsView.createHorizontalStack()
    private let row3 = DialsView.createHorizontalStack()
    private let row4 = DialsView.createHorizontalStack()
    
    // Main vertical stack
    private let mainStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 20
        stack.distribution = .fill
        return stack
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupKeypads()
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupKeypads()
        setupView()
    }
    
    private func setupKeypads() {
        one = createImageView(named: "one", action: #selector(numberTapped), tag: 1)
        two = createImageView(named: "two", action: #selector(numberTapped), tag: 2)
        three = createImageView(named: "three", action: #selector(numberTapped), tag: 3)
        four = createImageView(named: "four", action: #selector(numberTapped), tag: 4)
        five = createImageView(named: "five", action: #selector(numberTapped), tag: 5)
        six = createImageView(named: "six", action: #selector(numberTapped), tag: 6)
        seven = createImageView(named: "seven", action: #selector(numberTapped), tag: 7)
        eight = createImageView(named: "eight", action: #selector(numberTapped), tag: 8)
        nine = createImageView(named: "nine", action: #selector(numberTapped), tag: 9)
        zero = createImageView(named: "zero", action: #selector(numberTapped), tag: 0)
        clear = createImageView(named: "clear", action: #selector(specialButtonTapped), tag: 10)
        backspace = createImageView(named: "backspace", action: #selector(specialButtonTapped), tag: 11)
    }
    
    private func setupView() {
        backgroundColor = UIColor.Colors.viewBackground
        
        // Adding numbers and functions to rows
        row1.addArrangedSubview(one)
        row1.addArrangedSubview(two)
        row1.addArrangedSubview(three)
        
        row2.addArrangedSubview(four)
        row2.addArrangedSubview(five)
        row2.addArrangedSubview(six)
        
        row3.addArrangedSubview(seven)
        row3.addArrangedSubview(eight)
        row3.addArrangedSubview(nine)
        
        row4.addArrangedSubview(clear)
        row4.addArrangedSubview(zero)
        row4.addArrangedSubview(backspace)
        
        // Adding rows to main stack
        mainStack.addArrangedSubview(row1)
        mainStack.addArrangedSubview(row2)
        mainStack.addArrangedSubview(row3)
        mainStack.addArrangedSubview(row4)
        
        // Adding main stack to the view
        addSubview(mainStack)
        mainStack.translatesAutoresizingMaskIntoConstraints = false
        
        // Setting up constraints for main stack
        NSLayoutConstraint.activate([
            mainStack.centerXAnchor.constraint(equalTo: centerXAnchor),
            mainStack.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }
    
    @objc func numberTapped(_ sender: UITapGestureRecognizer) {
        guard let tappedImageView = sender.view as? UIImageView else { return }
        delegate?.numberTapped(tappedImageView.tag)
    }
    
    @objc func specialButtonTapped(_ sender: UITapGestureRecognizer) {
        guard let tappedImageView = sender.view as? UIImageView else { return }
        switch tappedImageView.tag {
        case 10:
            delegate?.clearTapped()
        case 11:
            delegate?.backspaceTapped()
        default:
            break
        }
    }
    
    // Utility to create an UIImageView
    private func createImageView(named name: String, action: Selector, tag: Int) -> UIImageView {
        let imageView = UIImageView()
        imageView.image = UIImage(named: name)
        imageView.contentMode = .center
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 80).isActive = true
        imageView.tag = tag
        
        let tapGesture = UITapGestureRecognizer(target: self, action: action)
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(tapGesture)
        
        return imageView
    }
    
    // Utility to create a horizontal stack view
    private static func createHorizontalStack() -> UIStackView {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 30
        stack.distribution = .fill
        return stack
    }
}

protocol DialsViewDelegate: AnyObject {
    func numberTapped(_ number: Int)
    func clearTapped()
    func backspaceTapped()
}
