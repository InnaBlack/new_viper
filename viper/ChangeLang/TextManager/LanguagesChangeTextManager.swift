import SferaBase

class LanguagesChangeTextManager: BaseTextManager {

}
extension LanguagesChangeTextManager: LanguagesChangeTextManagerProtocol {
    var title: String {
        ""
    }
    
    var titleLabel: String {
        //super.getValueWithKey(key: "LanguagesChange.Title.Label")
        // TODO: locatization
        ""
    }
    
    var saveButton: String {
        //super.getValueWithKey(key: "LanguagesChange.Save.Button")
        // TODO: locatization
        ""
    }
}
