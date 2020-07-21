//
//  MagicCropViewController.swift
//  Photo Editor
//
//  Created by Hakan Karakaya on 20.07.2020.
//  Copyright © 2020 Mohamed Hamed. All rights reserved.
//

import UIKit

public protocol MagicCropViewControllerDelegate: class {
    func magicCropViewController(_ controller: MagicCropViewController, didFinishCroppingImage image: UIImage)
    func magicCropViewControllerDidCancel(_ controller: MagicCropViewController)
}

open class MagicCropViewController: UIViewController {
    open weak var delegate: MagicCropViewControllerDelegate?
    open var image: UIImage? {
        didSet {
            cropView?.image = image
        }
    }

    fileprivate var cropView: ImageCropperView?
    open var toolbarHidden = false

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    open override func loadView() {
        let contentView = UIView()
        contentView.autoresizingMask = .flexibleWidth
        
        // Add CropView
        cropView = ImageCropperView(image: image)
        cropView!.contentMode = .scaleAspectFit
        contentView.addSubview(cropView!)
        
        view = contentView
        
        cropView!.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        cropView!.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier:1).isActive = true
        if #available(iOS 11.0, *) {
            cropView!.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor).isActive = true
        } else {
            // Fallback on earlier versions
        }
        cropView!.translatesAutoresizingMaskIntoConstraints = false
        cropView?.isUserInteractionEnabled = true
    }

    open override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.isTranslucent = false
        navigationController?.toolbar.isTranslucent = false
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(CropViewController.cancel(_:)))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(CropViewController.done(_:)))
        
        navigationController?.isToolbarHidden = toolbarHidden
        
        cropView?.image = image
    }
    
    open override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        cropView?.isUserInteractionEnabled = false
    }
    
    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    open func resetCropRect() {
        cropView?.resetCrop()
    }
    
    
    @objc func cancel(_ sender: UIBarButtonItem) {
        delegate?.magicCropViewControllerDidCancel(self)
    }
    
    @objc func done(_ sender: UIBarButtonItem) {
        if let image = cropView?.cropImage() {
            delegate?.magicCropViewController(self, didFinishCroppingImage: image)
        }
    }
}

