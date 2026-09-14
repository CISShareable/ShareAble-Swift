import SwiftUI

struct TermsConditionsView: View {
    var body: some View {
        LegalDocumentView(
            title: "Terms & Conditions",
            lastUpdated: "May 26, 2024",
            sections: [
                LegalSection(
                    heading: nil,
                    body: "Welcome to Shareable! These Terms and Conditions govern your use of the Shareable mobile application provided by CIS. By using the App, you agree to comply with and be bound by these Terms. Please read them carefully before using the App.\n歡迎使用 Shareable！本條款與條件規範您對由 CIS 提供的 Shareable 行動應用程式的使用。當您使用本應用程式時，即表示您同意遵守並受本條款約束。請在使用本應用程式前仔細閱讀。"
                ),
                LegalSection(
                    heading: "1. Acceptance of Terms / 1. 條款接受",
                    body: "By accessing or using the Shareable App, you acknowledge that you have read, understood, and agree to be bound by these Terms, including any additional guidelines and future modifications. If you do not agree to these Terms, you may not use the App.\n當您存取或使用 Shareable 應用程式時，即表示您已閱讀、理解並同意受本條款約束，包括任何額外指引及未來修改。如果您不同意本條款，則不得使用本應用程式。"
                ),
                LegalSection(
                    heading: "2. Use of the App / 2. 應用程式使用",
                    body: """
                    2.1 Eligibility / 2.1 資格
                    You must be at least 18 years old or the legal age of majority in your jurisdiction to use the App. You represent and warrant that you have the legal right and capacity to enter into these Terms.
                    您必須年滿 18 歲或在您管轄區域內達到法定成年年齡，方可使用本應用程式。您聲明並保證您具有法律權利及能力簽訂本條款。

                    2.2 Account Creation / 2.2 帳戶建立
                    To use certain features of the App, you may be required to create an account. You agree to provide accurate and complete information during the registration process. You are responsible for maintaining the confidentiality of your account credentials and for all activities that occur under your account.
                    要使用本應用程式的某些功能，您可能需要建立帳戶。您同意在註冊過程中提供準確且完整的資訊。您有責任維護帳戶憑證的機密性，並對帳戶下發生的所有活動負責。

                    2.3 Prohibited Activities / 2.3 禁止行為
                    You agree not to: use the App for any illegal, unauthorized, or prohibited purpose; violate any applicable laws, regulations, or third-party rights; interfere with or disrupt the App's functionality or servers; engage in any fraudulent or deceptive activities; harass, threaten, or harm other users; post or transmit any content that is abusive, defamatory, or obscene; use automated scripts, bots, or other unauthorized methods to access the App; or impersonate any person or entity.
                    您同意不得：將本應用程式用於任何非法、未經授權或禁止的目的；違反任何適用法律、法規或第三方權利；干擾或破壞本應用程式的功能或伺服器；從事任何欺詐或欺騙行為；騷擾、威脅或傷害其他使用者；發布或傳輸任何具有侮辱性、誹謗性或淫穢的內容；使用自動化腳本、機器人或其他未經授權的方法存取本應用程式；或冒充任何人或實體。
                    """
                ),
                LegalSection(
                    heading: "3. Content / 3. 內容",
                    body: """
                    3.1 User-Generated Content / 3.1 用戶生成內容
                    Shareable allows users to post, share, and exchange content, including text, images, and other materials ("User Content"). You retain ownership of your User Content, but by submitting it on the App, you grant the Company a non-exclusive, worldwide, royalty-free license to use, display, reproduce, and distribute your User Content in connection with the operation of the App.
                    Shareable 允許使用者發布、分享和交換內容，包括文字、圖片及其他材料（「用戶內容」）。您保留對用戶內容的所有權，但當您提交至本應用程式時，即授予本公司非專屬、全球性、免版稅的許可，以使用、展示、複製和分發您的用戶內容，用於本應用程式的運作。

                    3.2 Monitoring / 3.2 監控
                    The Company reserves the right to monitor User Content posted on the App and remove any content that violates these Terms or is deemed inappropriate in its sole discretion. However, the Company does not guarantee the accuracy, integrity, or quality of User Content.
                    本公司保留監控本應用程式上發布的用戶內容的權利，並可移除任何違反本條款或被本公司單方面認為不當的內容。然而，本公司不保證用戶內容的準確性、完整性或品質。

                    3.3 Intellectual Property / 3.3 智慧財產權
                    All intellectual property rights in the App, including trademarks, copyrights, and proprietary information, are the property of the Company or its licensors. You agree not to use, reproduce, modify, or distribute any intellectual property of the App without obtaining prior written permission from the Company.
                    本應用程式內所有智慧財產權，包括商標、著作權及專有資訊，均為本公司或其授權方之財產。您同意未經本公司事先書面許可，不得使用、複製、修改或分發本應用程式的任何智慧財產權。
                    """
                ),
                LegalSection(
                    heading: "4. Transactions and Listings / 4. 交易與刊登",
                    body: """
                    4.1 Transaction Responsibility / 4.1 交易責任
                    Shareable provides a platform for users to list, buy, and sell items. The Company is not a party to any transaction between users and bears no responsibility for the quality, safety, or legality of the listed items. Users are solely responsible for their interactions and transactions with other users.
                    Shareable 提供平台供使用者刊登、購買及出售物品。本公司並非使用者之間任何交易的當事人，對所刊登物品的品質、安全性或合法性不負任何責任。使用者須對其與其他使用者的互動及交易負全責。

                    4.2 Item Listings / 4.2 物品刊登
                    When listing items on the App, users must provide accurate and truthful information about the items. Users agree not to list prohibited items, such as illegal or counterfeit goods, hazardous materials, or items that infringe upon third-party rights.
                    當在本應用程式上刊登物品時，使用者必須提供物品的準確且真實資訊。使用者同意不得刊登禁止物品，例如非法或仿冒商品、危險物品或侵犯第三方權利的物品。
                    """
                ),
                LegalSection(
                    heading: "5. Privacy / 5. 隱私",
                    body: "Your privacy is important to us. Please review our Privacy Policy to understand how we collect, use, and disclose your personal information.\n您的隱私對我們至關重要。請查閱我們的隱私政策，以了解我們如何收集、使用及披露您的個人資料。"
                ),
                LegalSection(
                    heading: "6. Termination / 6. 終止",
                    body: "The Company reserves the right to suspend or terminate your access to the App, in whole or in part, without prior notice if you violate these Terms. Upon termination, your account and any associated data may be permanently deleted.\n若您違反本條款，本公司有權在無需事先通知的情況下，全部或部分暫停或終止您對本應用程式的存取。終止後，您的帳戶及相關資料可能被永久刪除。"
                ),
                LegalSection(
                    heading: "7. Disclaimer of Warranties / 7. 免責聲明",
                    body: "The App is provided on an \"as-is\" and \"as available\" basis. The Company makes no warranties or representations about the accuracy, reliability, or suitability of the App for any purpose. You use the App at your own risk.\n本應用程式按「現狀」及「可用性」提供。本公司對本應用程式的準確性、可靠性或適用性不作任何保證或聲明。您使用本應用程式需自行承擔風險。"
                ),
                LegalSection(
                    heading: "8. Limitation of Liability / 8. 責任限制",
                    body: "To the maximum extent permitted by law, the Company and its affiliates shall not be liable for any direct, indirect, incidental, consequential, or punitive damages arising out of or in connection with your use of the App.\n在法律允許的最大範圍內，本公司及其關聯公司對於您使用本應用程式所產生的任何直接、間接、附帶、衍生性或懲罰性損害不負任何責任。"
                ),
                LegalSection(
                    heading: "9. Indemnification / 9. 賠償",
                    body: "You agree to indemnify and hold harmless the Company and its affiliates from any claims, losses, liabilities, damages, and expenses (including attorney's fees) arising out of or in connection with your use of the App or any violation of these Terms.\n您同意賠償並使本公司及其關聯公司免於因您使用本應用程式或違反本條款而產生的任何索賠、損失、責任、損害及費用（包括律師費）。"
                ),
                LegalSection(
                    heading: "10. Modifications / 10. 修改",
                    body: "The Company reserves the right to modify or update these Terms at any time without prior notice. The updated Terms will be effective upon posting on the App. Your continued use of the App after the posting of the updated Terms constitutes your acceptance of the modifications.\n本公司有權隨時修改或更新本條款，無需事先通知。更新後的條款將於發布於本應用程式時生效。您在更新條款發布後繼續使用本應用程式，即表示您接受該修改。"
                ),
                LegalSection(
                    heading: "11. Severability / 11. 可分割性",
                    body: "If any provision of these Terms is held to be invalid or unenforceable, the remaining provisions shall continue to be valid and enforceable to the fullest extent permitted by law.\n若本條款任何條款被認定為無效或不可執行，其餘條款仍應在法律允許的最大範圍內繼續有效並可執行。"
                ),
                LegalSection(
                    heading: "12. Entire Agreement / 12. 完整協議",
                    body: "These Terms constitute the entire agreement between you and the Company regarding the use of the App and supersede any prior agreements or understandings, whether written or oral.\n本條款構成您與本公司之間關於本應用程式使用的完整協議，取代任何先前的書面或口頭協議或理解。\n\nIn the event of any dispute, the English version of these Terms shall prevail.\n如有任何爭議，本條款之英文版本為準。"
                ),
            ]
        )
    }
}
