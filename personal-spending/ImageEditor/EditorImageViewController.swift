//
//  EditorImageViewController.swift
//  ImageEditor
//
//  Created by Ly Truong H. VN.Danang on 29/06/2023.
//

import UIKit
import ZLImageEditor
import CoreImage
import PhotosUI

class EditorImageViewController: UIViewController {

    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var newImageView: UIImageView!
    @IBOutlet weak var previewImageView: UIImageView!
    @IBOutlet weak var alphaLabel: UILabel!
    @IBOutlet weak var alphaSlider: UISlider!
    @IBOutlet weak var nameImageLabel: UILabel!
    @IBOutlet weak var switchControl: UISwitch!
    @IBOutlet weak var imageAddButton: UIButton!

    var resultImageEditModel: ZLEditImageModel?
    var isImageAbove = false
    var alphaImageBelow: Float = 1.00
    var alphaImageAbove: Float = 0.50
    var isEditingNewImage = false

    var hasImage = false
    let image1 = UIImage(named: "below.png")!
    let image2 = UIImage(named: "above.png")!
    let image3 = UIImage(named: "combine_images.png")!

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Combine Images"
        // Đặt màu cho tiêu đề của thanh điều hướng
        let titleAttributes: [NSAttributedString.Key: Any] = [
                .foregroundColor: UIColor.systemBlue, // Màu của tiêu đề
            .font: UIFont.boldSystemFont(ofSize: 18) // Font chữ của tiêu đề
        ]
        navigationController?.navigationBar.titleTextAttributes = titleAttributes

        alphaLabel.text = "Opacity:   0.10"
        nameImageLabel.text = "Image below"
        mainImageView.image = image2
        newImageView.image = image2
        newImageView.alpha = 0.5
        previewImageView.image = image3
        isImageAbove = true

        addTapGesturePreviewImage()
        addTapGestureNewImage()
        createBarButton()

        ZLImageEditorConfiguration.default()
            .fontChooserContainerView(FontChooserContainerView())
            .editImageTools([.draw, .clip, .imageSticker, .textSticker, .mosaic, .filter, .adjust])
            .adjustTools([.brightness, .contrast, .saturation])
            .canRedo(true)

    }

    @IBAction func changeValueAlpha(_ sender: UISlider) {
//        newImageView.alpha = CGFloat(sender.value)
        let opacity = String(format: "%.2f", CGFloat(sender.value))
        alphaLabel.text = "Opacity:   \(opacity)"
        if isImageAbove {
            newImageView.alpha = CGFloat(sender.value)
            alphaImageAbove = Float(CGFloat(sender.value))
        } else {
            mainImageView.alpha = CGFloat(sender.value)
            alphaImageBelow = Float(CGFloat(sender.value))
        }
    }

    @IBAction func addImage(_ sender: Any) {
        alertAction()
    }

    @IBAction func preview(_ sender: Any) {
        combineImage()
    }

    @IBAction func saveImageToAlbum(_ sender: Any) {
        UIImageWriteToSavedPhotosAlbum(previewImageView.image ?? image2, self, #selector(saveDone), nil)
    }

    @IBAction func switchImage(_ sender: UISwitch) {
        nameImageLabel.text = sender.isOn ? "Image above" : "Image below"
        isImageAbove = sender.isOn
        if isImageAbove {
            alphaSlider.value = alphaImageAbove
            alphaLabel.text = "Opacity:   \(String(format: "%.2f", alphaImageAbove))"
        } else {
            alphaLabel.text = "Opacity:   \(String(format: "%.2f", alphaImageBelow))"
            alphaSlider.value = alphaImageBelow
        }
    }

    func addButtonHome() {
    }

    func addButtonReset() {

        let customButton = UIButton(type: .custom)
        customButton.setImage(UIImage(named: "reset_icon"), for: .normal)
        customButton.addTarget(self, action: #selector(resetButtonTapped), for: .touchUpInside)

        let backButton = UIBarButtonItem(title: "Home", style: .plain, target: self, action: #selector(backButtonTapped))

        let customButtonItem = UIBarButtonItem(customView: customButton)
        navigationItem.leftBarButtonItems = [backButton, customButtonItem]
    }

    func addTapGestureNewImage() {
        newImageView.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageNewTapped))
        newImageView.addGestureRecognizer(tapGesture)
    }

    func addTapGesturePreviewImage() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        previewImageView.isUserInteractionEnabled = true
        previewImageView.addGestureRecognizer(tapGesture)
    }

    func createBarButton() {
        // Tạo nút rightBarButton với tiêu đề "Edit"
        let rightBarButton = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(editButtonTapped))
        navigationItem.rightBarButtonItem = rightBarButton
        addButtonHome()
        addButtonReset()
    }

    func editImage(_ image: UIImage, editModel: ZLEditImageModel?) {
        ZLEditImageViewController.showEditImageVC(parentVC: self, image: image, editModel: nil) { [weak self] resImage, editModel in
            guard let this = self else { return }
            DispatchQueue.main.async {
                if this.isEditingNewImage {
                    if this.isImageAbove {
                        this.newImageView.image = resImage
                    } else {
                        this.mainImageView.image = resImage
                    }
                } else {
                    this.previewImageView.image = resImage
                }
                this.resultImageEditModel = editModel
            }
        }
    }
    
    func addPhotoLibrary() {
        if #available(iOS 14.0, *) {
            var configuration = PHPickerConfiguration()
            configuration.filter = .images
            configuration.selectionLimit = 1

            let picker = PHPickerViewController(configuration: configuration)
            picker.delegate = self
            present(picker, animated: true, completion: nil)
        } else {
            choosePhoto(sourceType: .photoLibrary)
        }
    }

    func alertAction() {
        let alertController = UIAlertController(title: "Add Photos", message: nil, preferredStyle: .actionSheet)

        let cameraAction = UIAlertAction(title: "Camera", style: .default) { (_) in
            self.choosePhoto(sourceType: .camera)
        }

        let libraryAction = UIAlertAction(title: "Library", style: .default) { (_) in
            self.addPhotoLibrary()
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

        alertController.popoverPresentationController?.sourceView = imageAddButton
        alertController.popoverPresentationController?.sourceRect = imageAddButton.bounds

        // Hiển thị UIAlertController

        alertController.addAction(cameraAction)
        alertController.addAction(libraryAction)
        alertController.addAction(cancelAction)

        present(alertController, animated: true, completion: nil)
    }

    func choosePhoto(sourceType: UIImagePickerController.SourceType) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = sourceType
//        showDetailViewController(imagePickerController, sender: nil)
        present(imagePickerController, animated: true, completion: nil)
    }

    func combineImage() {
//        let maxLen = 1024 * 1024 * 100 // 100mb
        print("check combine in here")
        let combinedImage = combineImages(image1: mainImageView.image, image2: newImageView.image)

        // Hiển thị hình ảnh kết hợp trên imageView
        previewImageView.image = combinedImage
        mainImageView.image = combinedImage
    }

    func showErrorMessage() {
        let alert = UIAlertController(title: "Error", message: "Cannot process image", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)

//        // Hiển thị alert
//        if let viewController = UIApplication.shared.keyWindow?.rootViewController {
//            viewController.present(alert, animated: true, completion: nil)
//        }
        present(alert, animated: true)
    }

    func combineImages(image1: UIImage?, image2: UIImage?) -> UIImage? {
        guard let image1 = image1, let image2 = image2 else { return nil }
        let newSize = image1.size // Kích thước mới là kích thước của hình ảnh thứ nhất

        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)

        // Vẽ hình ảnh thứ nhất
        image1.draw(in: CGRect(origin: CGPoint.zero, size: newSize))

        // Tính toán kích thước mới và vị trí của hình ảnh thứ hai
        let aspectRatio1 = image1.size.width / image1.size.height
        let aspectRatio2 = image2.size.width / image2.size.height
        let targetRect: CGRect

        if aspectRatio1 > aspectRatio2 {
            let targetWidth = newSize.width
            let targetHeight = newSize.width / aspectRatio2
            let yOffset = (newSize.height - targetHeight) / 2
            targetRect = CGRect(x: 0, y: yOffset, width: targetWidth, height: targetHeight)
        } else {
            let targetWidth = newSize.height * aspectRatio2
            let targetHeight = newSize.height
            let xOffset = (newSize.width - targetWidth) / 2
            targetRect = CGRect(x: xOffset, y: 0, width: targetWidth, height: targetHeight)
        }

        // Vẽ hình ảnh thứ hai với content mode là aspectFill
        image2.draw(in: targetRect, blendMode: .normal, alpha: newImageView.alpha)

        let combinedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return combinedImage
    }

    @objc func customButtonTapped() {
        // Xử lý sự kiện khi nút được nhấn
    }

    @objc func backButtonTapped() {
        let vc = WelcomeViewController()
        UIApplication.shared.windows.first?.rootViewController = vc
        UIApplication.shared.windows.first?.makeKeyAndVisible()
    }

    @objc func saveDone(_ image: UIImage, error: Error?, context: UnsafeMutableRawPointer?) {
        let alert = UIAlertController(title: nil, message: "Save To Album", preferredStyle: .alert)
        if let err = error {
            alert.addAction(UIAlertAction(title: err.localizedDescription, style: .destructive))
        } else {
            alert.addAction(UIAlertAction(title: "Done", style: .destructive))
        }
        self.present(alert, animated: true)
    }

    @objc func imageNewTapped() {
        isEditingNewImage = true
        var image = newImageView.image!
        if !isImageAbove {
            image = mainImageView.image!
        }
        guard let imageData = image.jpegData(compressionQuality: 1) else {
            showErrorMessage()
            return
        }

        if let combinedImageDataWithHighQuality = UIImage(data: imageData) {
            editImage(combinedImageDataWithHighQuality, editModel: resultImageEditModel)
        } else {
            editImage(image, editModel: resultImageEditModel)
        }
    }

    @objc func imageTapped() {
        isEditingNewImage = false
//        editImage(previewImageView.image!, editModel: resultImageEditModel)
        guard let imageData = previewImageView.image!.jpegData(compressionQuality: 1) else {
            showErrorMessage()
            return
        }
        print("data byte: \(imageData.count)")

        if let combinedImageDataWithHighQuality = UIImage(data: imageData) {
            editImage(combinedImageDataWithHighQuality, editModel: resultImageEditModel)
        } else {
            editImage(previewImageView.image!, editModel: resultImageEditModel)
        }
    }

    @objc func editButtonTapped() {
        isEditingNewImage = false
        guard let imageData = previewImageView.image!.jpegData(compressionQuality: 1) else {
            showErrorMessage()
            return
        }
        print("data byte: \(imageData.count)")

        if let combinedImageDataWithHighQuality = UIImage(data: imageData) {
            editImage(combinedImageDataWithHighQuality, editModel: resultImageEditModel)
        } else {
            editImage(previewImageView.image!, editModel: resultImageEditModel)
        }
    }

    @objc func resetButtonTapped() {
        hasImage = false
        alphaLabel.text = "Opacity:   1.00"
        nameImageLabel.text = "Image below"
        mainImageView.image = image2
        newImageView.image = image2
        previewImageView.image = image3
        newImageView.alpha = 0.5
        mainImageView.alpha = 1.0
        alphaImageBelow = 1.00
        alphaImageAbove = 0.50
        switchControl.isOn = false
        alphaSlider.value = alphaImageBelow
    }
}

extension EditorImageViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            // Xử lý ảnh đã chọn hoặc chụp tại đây
            if hasImage && switchControl.isOn {
                newImageView.image = pickedImage
                newImageView.alpha = CGFloat(alphaImageAbove)
                alphaLabel.text = "Opacity:   \(String(format: "%.2f", alphaImageAbove))"
                nameImageLabel.text = "Image above"
                switchControl.isOn = true
                alphaSlider.value = alphaImageAbove
                isImageAbove = true
            } else {
                mainImageView.image = pickedImage
                mainImageView.alpha = CGFloat(alphaImageBelow)
                alphaLabel.text = "Opacity:   \(String(format: "%.2f", alphaImageBelow))"
                nameImageLabel.text = "Image below"
                switchControl.isOn = false
                alphaSlider.value = alphaImageBelow
                isImageAbove = false
                hasImage = true
            }
        }

        picker.dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

extension EditorImageViewController: PHPickerViewControllerDelegate {
    @available(iOS 14.0, *)
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true, completion: nil)

        guard !results.isEmpty else {
            return
        }

        let itemProvider = results[0].itemProvider
        if itemProvider.canLoadObject(ofClass: UIImage.self) {
            itemProvider.loadObject(ofClass: UIImage.self) { [weak self] (image, error) in
                guard let this = self else { return }
                if let pickedImage = image as? UIImage {
                    DispatchQueue.main.async {
                        // Xử lý ảnh đã chọn hoặc chụp tại đây
                        if this.hasImage && this.switchControl.isOn {
                            this.newImageView.image = pickedImage
                            this.newImageView.alpha = CGFloat(this.alphaImageAbove)
                            this.alphaLabel.text = "Opacity:   \(String(format: "%.2f", this.alphaImageAbove))"
                            this.nameImageLabel.text = "Image above"
                            this.switchControl.isOn = true
                            this.alphaSlider.value = this.alphaImageAbove
                            this.isImageAbove = true
                        } else {
                            this.mainImageView.image = pickedImage
                            this.mainImageView.alpha = CGFloat(this.alphaImageBelow)
                            this.alphaLabel.text = "Opacity:   \(String(format: "%.2f", this.alphaImageBelow))"
                            this.nameImageLabel.text = "Image below"
                            this.switchControl.isOn = false
                            this.alphaSlider.value = this.alphaImageBelow
                            this.isImageAbove = false
                            this.hasImage = true
                        }
                    }
                }
            }
        }
    }
}
