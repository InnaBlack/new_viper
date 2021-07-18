protocol LanguagesChangeViewInput: AnyObject {
    func updateTexts()
    func showLoader()
    func hideLoader()
    func showError(with message: String)
}
