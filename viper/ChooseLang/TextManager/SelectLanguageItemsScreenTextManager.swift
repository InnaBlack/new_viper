import SferaBase

class SelectLanguageItemsScreenTextManager: BaseTextManager {

}
extension SelectLanguageItemsScreenTextManager: SelectLanguageItemsScreenTextManagerProtocol {
    var title: String {
        //super.getValueWithKey(key: "SelectSearchableItemsScreen.Object.Title")
        ""
    }
    
    var selectLang: String {
        //super.getValueWithKey(key: "SelectSearchableItemsScreen.Label.SelectLang")
        // TODO: locatization
       ""
    }

    var search: String {
        super.getValueWithKey(key: "PassionListScreen.SearchBar.SearchFieldPlaceholder")
    }
}
