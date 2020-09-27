#if canImport(UIKit)
import UIKit

public final class BottomSheetView: UIView {
    
    public enum HandleStyle: CaseIterable {
        case none, inside, outside
    }
    
    public var handleStyle: HandleStyle = .none {
        willSet {
            setHandle(for: newValue)
            setNeedsLayout()
        }
    }
        
    /// Ancdhors the top of the `contentView` to its superview
    lazy var contentViewTopAnchor = contentView.topAnchor.constraint(equalTo: topAnchor)
    /// Anchors the top of `contentView` to the bottom of `dragHandle`. Used for `outside` handle style.
    lazy var contentViewTopAnchorToHandle = contentView.topAnchor.constraint(equalTo: dragHandle.bottomAnchor, constant: 16)
    
    private lazy var dragHandle: UIView = {
        let view = UIView()
        view.backgroundColor = dragHandleColor
        view.layer.cornerRadius = 2
        return view
    }()
    
    public var contentView: UIView = UIView() {
        didSet {
            setHandle(for: handleStyle)
            setContentView()
        }
    }
    
    public var cornerRadius: CGFloat = 16 {
        willSet {
            setCornerRadius(newValue)
        }
    }
    
    public var dragHandleColor: UIColor = .systemFill {
        willSet {
            dragHandle.backgroundColor = newValue
        }
    }
    
    public var contentBackgroundColor: UIColor = .systemBackground {
        willSet {
            contentView.backgroundColor = newValue
        }
    }

    public init(handleStyle: HandleStyle) {
        self.handleStyle = handleStyle
        super.init(frame: .zero)
        
        backgroundColor = .clear

        addSubview(contentView)
        setContentView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .clear

        addSubview(contentView)
        setContentView()
        
        setHandle(for: .none)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)

        backgroundColor = .clear

        addSubview(contentView)
        setContentView()
        setHandle(for: .none)
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        setCornerRadius(cornerRadius)
    }
    
    private func setContentView() {
        contentView.backgroundColor = contentBackgroundColor
        setContentViewConstraints()
    }
    
    private func setCornerRadius(_ radius: CGFloat) {
        contentView.roundCorners(corners: [.topLeft, .topRight], radius: radius)
    }
    
    private func setContentViewConstraints() {
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            contentView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    private func setHandle(for style: HandleStyle) {
        switch style {
            case .none:
                dragHandle.removeFromSuperview()
                contentViewTopAnchor.isActive = true
            case .inside, .outside:
                addSubview(dragHandle)
                contentViewTopAnchor.isActive = style == .inside
                contentViewTopAnchorToHandle.isActive = style == .outside
                
                dragHandle.translatesAutoresizingMaskIntoConstraints = false
                
                NSLayoutConstraint.activate([
                    dragHandle.topAnchor.constraint(equalTo: topAnchor, constant: style == .inside ? 12 : 0),
                    dragHandle.centerXAnchor.constraint(equalTo: centerXAnchor),
                    dragHandle.widthAnchor.constraint(equalToConstant: 40),
                    dragHandle.heightAnchor.constraint(equalToConstant: 4)
                ])
        }
    }
    
}

#endif

#if canImport(UIKit) && canImport(SwiftUI)
import SwiftUI

struct BottomSheetViewRepresentable: UIViewRepresentable {
    typealias UIViewType = BottomSheetView
    
    var handleStyle: BottomSheetView.HandleStyle
    
    func makeUIView(context: Context) -> BottomSheetView {
        let view = BottomSheetView(handleStyle: handleStyle)
        return view
    }
    
    func updateUIView(_ uiView: BottomSheetView, context: Context) {
        uiView.handleStyle = handleStyle
    }
}

struct BottomSheetViewPreview: PreviewProvider {
    static var previews: some View {
        ForEach(BottomSheetView.HandleStyle.allCases, id: \.self) { style in
            BottomSheetViewRepresentable(handleStyle: style)
                .previewLayout(.fixed(width: 375, height: 460))
        }
    }
}
#endif