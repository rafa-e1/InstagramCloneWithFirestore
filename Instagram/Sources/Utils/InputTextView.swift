//
//  InputTextView.swift
//  Instagram
//
//  Created by RAFA on 7/7/24.
//

import UIKit

import SnapKit
import Then

final class InputTextView: UITextView {
    
    // MARK: - Properties
    
    var placeholderText: String? {
        didSet { placeholderLabel.text = placeholderText }
    }

    var placeholderShouldCenter = true {
        didSet { updatePlaceholderConstraints() }
    }

    let placeholderLabel = UILabel()
    
    // MARK: - Initializer

    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        
        setAddObservers()
        setStyle()
        setHierarchy()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Actions
    
    @objc private func handleTextDidChange() {
        placeholderLabel.isHidden = !text.isEmpty
    }

    // MARK: - Helpers

    private func setAddObservers() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleTextDidChange),
            name: UITextView.textDidChangeNotification,
            object: nil
        )
    }

    // MARK: - UI

    private func setStyle() {
        placeholderLabel.textColor = .lightGray
    }

    private func setHierarchy() {
        addSubview(placeholderLabel)
    }

    private func updatePlaceholderConstraints() {
        placeholderLabel.snp.removeConstraints()

        if placeholderShouldCenter {
            placeholderLabel.snp.makeConstraints {
                $0.centerY.trailing.equalToSuperview()
                $0.leading.equalTo(8)
            }
        } else {
            placeholderLabel.snp.makeConstraints {
                $0.top.equalTo(8)
                $0.leading.equalTo(6)
            }
        }
    }
}
