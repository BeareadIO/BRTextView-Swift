//
//  BRTextView.swift
//  BRTextView-Swift
//
//  Created by Chao Zhang on 2017/12/14.
//  Copyright © 2017年 bearead. All rights reserved.
//

import UIKit

@IBDesignable
public class BRTextView: UITextView, NSLayoutManagerDelegate {
    
    @IBInspectable public var placeholder: String = "" {
        didSet {
            lblPlaceholder.text = placeholder
        }
    }
    
    @IBInspectable public var placeholderColor: UIColor = UIColor(red: 0, green: 0, blue: 0.1, alpha: 0.22) {
        didSet {
            lblPlaceholder.textColor = placeholderColor
        }
    }
    
    @IBInspectable public var needUnderLine: Bool = true {
        didSet {
            underline.isHidden = !needUnderLine
        }
    }
    
    @IBInspectable public var underlineColor: UIColor = UIColor.gray {
        didSet {
            underline.backgroundColor = underlineColor
        }
    }
    
    public var textInsets: UIEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0) {
        didSet {
            updateMinAndMaxHeight()
        }
    }
    
    @IBInspectable public var ib_textInsets: String = "" {
        didSet {
            textInsets = UIEdgeInsetsFromString(ib_textInsets)
        }
    }
    
    @IBInspectable public var lineSpacing: CGFloat = 6 {
        didSet {
            updateMinAndMaxHeight()
        }
    }
    
    @IBInspectable public var maximumNumberOfLines: Int = 1 {
        didSet {
            updateMinAndMaxHeight()
        }
    }
    
    override public var textAlignment: NSTextAlignment {
        didSet {
            lblPlaceholder.textAlignment = textAlignment
        }
    }
    
    override public var font: UIFont? {
        didSet {
            lblPlaceholder.font = font!
            updateMinAndMaxHeight()
        }
    }
    
    override public var text: String! {
        didSet {
            lblPlaceholder.isHidden = text.count > 0
        }
    }
    
    private lazy var lblPlaceholder: UILabel = {
        let label = UILabel(frame: self.bounds)
        label.textColor = UIColor(red: 0, green: 0, blue: 0.1, alpha: 0.22)
        label.textAlignment = self.textAlignment
        label.font = self.font
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var underline: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.lightGray
        return view
    }()
    
    private var maxHeight: CGFloat = 0
    private var minHeight: CGFloat = 0
    
    deinit {
        NotificationCenter().removeObserver(self)
    }
    
    override public var intrinsicContentSize: CGSize {
        var height = sizeThatFits(CGSize(width: bounds.size.width, height: CGFloat(MAXFLOAT))).height
        if (minHeight > 0) {
            height = height > minHeight ? height : minHeight;
        }
        if (maxHeight > 0) {
            height = height > maxHeight ? maxHeight : height;
        }
        return CGSize(width: UIViewNoIntrinsicMetric, height: height)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        propertyInit()
        updateUI()
    }
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        propertyInit()
        updateUI()
    }
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        updateUI()
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        
        textContainer.lineFragmentPadding = 0
        textContainerInset = textInsets
        var height = sizeThatFits(CGSize(width: bounds.size.width, height: CGFloat(MAXFLOAT))).height
        if minHeight > 0 {
            height = height > minHeight ? height : minHeight
        }
        if maxHeight > 0 {
            height = height > maxHeight ? maxHeight : height;
        }
        frame.size.height = height
        updateFrame()
    }
    
    private func propertyInit() {
        font = UIFont.systemFont(ofSize: 17)
    }
    
    private func updateUI() {
        addSubview(underline)
        addSubview(lblPlaceholder)
        layoutManager.delegate = self
        layoutManager.allowsNonContiguousLayout = false
        updateFrame()
        addObserverOrAction()
        invalidateIntrinsicContentSize()
    }
    
    private func updateFrame() {
        lblPlaceholder.frame = CGRect(x: textContainerInset.left, y: textContainerInset.top, width: contentSize.width - textContainerInset.left - textContainerInset.right, height: contentSize.height - textContainerInset.top - textContainerInset.bottom)
        underline.frame = CGRect(x: 0, y: bounds.size.height - 1 + bounds.origin.y, width: bounds.size.width, height: 1)
    }
    
    override public func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        
        lblPlaceholder.frame = CGRect(x: textContainerInset.left, y: textContainerInset.top, width: contentSize.width - textContainerInset.left - textContainerInset.right, height: contentSize.height - textContainerInset.top - textContainerInset.bottom)
        underline.frame = CGRect(x: 0, y: bounds.size.height - 1 + bounds.origin.y, width: bounds.size.width, height: 1)
    }
    
    private func addObserverOrAction() {
        NotificationCenter.default.addObserver(self, selector: #selector(inputDidChange), name: .UITextViewTextDidChange, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(inputDidBegin), name: .UITextViewTextDidBeginEditing, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(inputDidEnd), name: .UITextViewTextDidEndEditing, object: nil)
    }
    
    private func updateMinAndMaxHeight() {
        maxHeight = CGFloat(maximumNumberOfLines) * font!.lineHeight + CGFloat(maximumNumberOfLines) * lineSpacing + textInsets.top + textInsets.bottom
        minHeight = font!.lineHeight + lineSpacing + textInsets.top + textInsets.bottom
        setNeedsLayout()
        invalidateIntrinsicContentSize()
    }
    
    public func layoutManager(_ layoutManager: NSLayoutManager, lineSpacingAfterGlyphAt glyphIndex: Int, withProposedLineFragmentRect rect: CGRect) -> CGFloat {
        return lineSpacing
    }
    
    @objc private func inputDidBegin() {
        
    }
    
    @objc private func inputDidEnd() {
        
    }
    
    @objc private func inputDidChange() {
        lblPlaceholder.isHidden = text.count > 0
        invalidateIntrinsicContentSize()
    }
}
