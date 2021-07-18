protocol SelectLanguageItemsScreenViewInput: AnyObject {
    func updateTexts()
    
    func showLoader()
    func hideLoader()
    func setTitle(title: String?)
}
