import SwiftUI

struct PrivacyPolicyView: View {
    var body: some View {
        LegalDocumentView(
            title: "Privacy Policy",
            lastUpdated: "May 26, 2024 / 2024年5月26日",
            sections: [
                LegalSection(
                    heading: nil,
                    body: "Thank you for using Shareable! This Privacy Policy explains how we collect, use, disclose, and protect your personal information when you use the Shareable mobile application provided by CIS. By using the App, you consent to the data practices described in this Policy.\n感謝您使用 Shareable！本《隱私權政策》說明我們在您使用由 CIS 提供的 Shareable 行動應用程式時，如何收集、使用、披露及保護您的個人資料。使用本應用程式即表示您同意本政策中所述的資料處理方式。"
                ),
                LegalSection(
                    heading: "1. Information We Collect / 1. 我們收集的資訊",
                    body: """
                    1.1 Personal Information / 1.1 個人資料
                    When you create an account or use certain features of the App, we may collect personal information such as your name, email address, phone number, and postal address. We may also collect payment information and transaction details when you make purchases or sell items through the App.
                    當您建立帳號或使用應用程式的特定功能時，我們可能會收集您的個人資料，例如姓名、電子郵件地址、電話號碼及郵寄地址。當您透過應用程式購買或銷售物品時，我們也可能會收集付款資訊與交易詳情。

                    1.2 Usage Information / 1.2 使用資訊
                    We collect information about how you interact with the App, including your device information, IP address, browser type, operating system, and usage patterns. This information helps us improve the functionality and performance of the App and provide you with a personalized experience.
                    我們會收集您與應用程式互動的相關資訊，包括裝置資料、IP 位址、瀏覽器類型、作業系統及使用模式。這些資訊有助於我們改進應用程式的功能與效能，並為您提供個人化體驗。

                    1.3 Location Information / 1.3 位置資訊
                    With your consent, we may collect and process your precise location information to provide location-based services and enhance your experience within the App. You can enable or disable location services through your device settings or the App's settings.
                    經您同意後，我們可能會收集並處理您的精確位置資訊，以提供基於位置的服務並提升應用體驗。您可透過裝置設定或應用程式設定啟用或停用位置服務。
                    """
                ),
                LegalSection(
                    heading: "2. Use of Collected Information / 2. 收集資訊的使用方式",
                    body: """
                    2.1 Provide and Personalize Services / 2.1 提供並個人化服務
                    We use the collected information to operate, maintain, and improve the App's features and services. This includes facilitating transactions, verifying your identity, providing customer support, and customizing your experience based on your preferences.
                    我們使用所收集的資訊以營運、維護並改進應用程式的功能與服務。這包括促進交易、驗證您的身分、提供客戶支援，以及根據您的偏好客製化使用體驗。

                    2.2 Communication / 2.2 溝通交流
                    We may use your email address or phone number to send you important notifications, updates, and promotional messages related to the App. You can opt-out of receiving promotional communications by following the instructions in the messages or contacting us directly.
                    我們可能使用您的電子郵件或電話號碼向您發送與應用程式相關的重要通知、更新或促銷訊息。您可依照訊息內的指示或直接聯絡我們，以選擇不再接收促銷資訊。

                    2.3 Analytics and Research / 2.3 數據分析與研究
                    We may analyze and aggregate data to understand how users interact with the App, improve our services, and conduct research. This data is anonymized and does not identify individual users.
                    我們可能分析與彙整資料，以了解使用者與應用程式的互動方式，改進我們的服務並進行研究。這些資料均已匿名化，不會識別個別使用者身份。

                    2.4 Legal Compliance / 2.4 法律遵循
                    We may use your information to comply with applicable laws, regulations, or legal obligations, including responding to legal requests and protecting our rights, privacy, safety, or property, as well as that of our users and the public.
                    我們可能使用您的資訊以遵守適用的法律、法規或法律義務，包括回應法律要求，並保護我們及使用者和公眾的權利、隱私、安全與財產。
                    """
                ),
                LegalSection(
                    heading: "3. Disclosure of Information / 3. 資訊揭露",
                    body: """
                    3.1 Service Providers / 3.1 服務供應商
                    We may share your information with trusted third-party service providers who assist us in operating the App, such as hosting, data storage, payment processing, analytics, and customer support. These service providers are contractually obligated to handle your information securely and only for the purposes specified by us.
                    我們可能會與受信任的第三方服務供應商共享您的資訊，這些供應商協助我們運行應用程式，例如主機託管、資料儲存、付款處理、分析及客戶支援等。這些供應商在合約中被要求安全地處理您的資訊，並僅依我們指定的用途使用。

                    3.2 Business Transfers / 3.2 業務轉讓
                    In the event of a merger, acquisition, or sale of all or a portion of our assets, your information may be transferred to the acquiring entity. We will notify you before your personal information becomes subject to a different privacy policy.
                    若我們發生合併、收購或全部或部分資產的出售，您的資訊可能會轉移至收購方。在您的個人資料受不同隱私政策約束之前，我們將提前通知您。

                    3.3 Legal Requirements / 3.3 法律要求
                    We may disclose your information if we believe it is necessary to comply with applicable laws, regulations, legal processes, or enforceable governmental requests. We may also disclose your information to protect our rights, privacy, safety, or property, as well as that of our users and the public.
                    若我們認為有必要遵守相關法律、法規、法律程序或可執行的政府要求，我們可能會披露您的資訊。我們也可能為保護我們及使用者與公眾的權利、隱私、安全或財產而揭露資訊。
                    """
                ),
                LegalSection(
                    heading: "4. Data Security / 4. 資料安全",
                    body: "We take reasonable measures to protect your personal information from unauthorized access, loss, misuse, alteration, or disclosure. However, please note that no method of transmission over the internet or electronic storage is 100% secure. Therefore, while we strive to use commercially acceptable means to protect your information, we cannot guarantee its absolute security.\n我們採取合理措施保護您的個人資料，防止未經授權的存取、遺失、濫用、修改或揭露。然而，請注意，網路傳輸或電子儲存方式皆無法達到百分之百安全。因此，儘管我們努力使用商業上可接受的方式保護您的資訊，但無法保證絕對安全。"
                ),
                LegalSection(
                    heading: "5. Your Choices / 5. 您的選擇",
                    body: """
                    5.1 Account Information / 5.1 帳號資訊
                    You can review, update, or delete your account information by accessing your account settings within the App. Please note that deleting your account may result in the permanent loss of your data associated with the account.
                    您可透過應用程式中的帳號設定檢視、更新或刪除您的帳號資訊。請注意，刪除帳號將導致與該帳號相關的資料永久遺失。

                    5.2 Location Information / 5.2 位置資訊
                    You can enable or disable location services through your device settings or the App's settings.
                    您可透過裝置設定或應用程式設定啟用或停用位置服務。

                    5.3 Marketing Communications / 5.3 行銷通信
                    You can opt-out of receiving promotional communications by following the instructions in the messages or contacting us directly.
                    您可依照訊息中的指示或直接聯絡我們，以選擇不再接收促銷資訊。
                    """
                ),
                LegalSection(
                    heading: "6. Third-Party Links and Services / 6. 第三方連結與服務",
                    body: "The App may contain links to third-party websites, applications, or services that are not owned or controlled by us. This Privacy Policy does not apply to such third-party platforms. We encourage you to review the privacy policies of those third parties before providing them with your personal information.\n本應用程式可能包含非本公司擁有或控制的第三方網站、應用程式或服務連結。本《隱私權政策》不適用於這些第三方平台。我們建議您在提供個人資料前，先閱讀該等第三方的隱私政策。"
                ),
                LegalSection(
                    heading: "7. Changes to this Privacy Policy / 7. 隱私權政策的變更",
                    body: "We may update this Privacy Policy from time to time. The updated version will be indicated by the \"Last Updated\" date at the beginning of this Policy. Please review this Privacy Policy carefully. By continuing to use the Shareable App, you acknowledge and agree to the practices described in this Policy. If you have any questions or concerns about our Privacy Policy or data practices, please contact us at shareable@cis.edu.hk\n我們可能會不時更新本《隱私權政策》。更新版本將由開頭的「最後更新日期」標示。請仔細閱讀本政策。繼續使用 Shareable 應用程式即表示您確認並同意本政策所述的做法。若您對本《隱私權政策》或資料處理方式有任何疑問或疑慮，請聯絡我們：shareable@cis.edu.hk。"
                ),
                LegalSection(
                    heading: nil,
                    body: "In the event of any dispute, the English version of these Terms shall prevail.\n如有任何爭議，本條款之英文版本為準。"
                ),
            ]
        )
    }
}
