//
//  HanziPinyinExampleViewController.swift
//  HanziPinyinExample
//
//  Created by Xin Hong on 16/4/16.
//  Copyright © 2016年 Teambition. All rights reserved.
//

import UIKit
import HanziPinyin

class HanziPinyinExampleViewController: UIViewController {
    @IBOutlet weak var inputTextField: UITextField!
    @IBOutlet weak var outputTextView: UITextView!
    @IBOutlet weak var pinyinButton: ActivityButton!

    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    // MARK: - Helper
    fileprivate func setupUI() {
        navigationItem.title = "HanziPinyin"
        inputTextField.returnKeyType = .done
        inputTextField.placeholder = "Chinese characters..."
        outputTextView.text = nil
        inputTextField.delegate = self
        pinyinButton.isEnabled = false
        NotificationCenter.default.addObserver(self, selector: #selector(inputTextFieldTextChanged(_:)), name: .UITextFieldTextDidChange, object: inputTextField)
    }

    // MARK: - Actions
    @IBAction func pinyinButtonTapped(_ sender: UIButton) {
        guard let text = inputTextField.text else {
            return
        }

        inputTextField.resignFirstResponder()
        let startTime = Date().timeIntervalSince1970
        pinyinButton.startAnimating()
        text.toPinyin { (pinyin) in
            self.pinyinButton.stopAnimating()
            let endTime = NSDate().timeIntervalSince1970
            let totalTime = endTime - startTime
            self.outputTextView.text = "Total Time:" + "\n" + "\(totalTime) (s)" + "\n\n" + "Pinyin:" + "\n" + pinyin
        }
    }

    @IBAction func backgroundTapped(_ sender: UIControl) {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }

    func inputTextFieldTextChanged(_ notification: Notification) {
        pinyinButton.isEnabled = (inputTextField.text?.characters.count ?? 0) > 0
    }
}

extension HanziPinyinExampleViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        inputTextField.resignFirstResponder()
        return true
    }
}
