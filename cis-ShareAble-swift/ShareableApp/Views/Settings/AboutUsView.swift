import SwiftUI

/// Replaces aboutUs.html
struct AboutUsView: View {
    var body: some View {
        LegalDocumentView(
            title: "About",
            sections: [
                LegalSection(
                    heading: "Shareable - Connecting People, Sharing Experiences\nShareable - 連結人們，共享體驗",
                    body: "Welcome to Shareable, the innovative mobile application that brings people together and facilitates the sharing of experiences, skills, and resources. Our mission is to create a vibrant and connected community where individuals can connect, collaborate, and benefit from each other's knowledge and resources.\n歡迎使用 Shareable，一款創新的行動應用程式，致力於將人們連結在一起，促進經驗、技能與資源的分享。我們的使命是建立一個充滿活力、互相連結的社群，讓每個人都能交流、合作，並從彼此的知識與資源中受益。"
                ),
                LegalSection(
                    heading: "Our Vision\n我們的願景",
                    body: "At Shareable, we envision a world where people can easily share their expertise, experiences, and resources with others, fostering a sense of community and empowerment. We believe that everyone has something valuable to offer and that by sharing our skills, knowledge, and resources, we can make a positive impact on each other's lives.\n在 Shareable，我們期望建立一個世界，讓人們能輕鬆地與他人分享自己的專業、經驗與資源，從而培養社群意識與自我成長。我們相信每個人都有值得分享的價值，透過技能、知識與資源的交流，我們能彼此帶來正面的影響。"
                ),
                LegalSection(
                    heading: "How It Works\n運作方式",
                    body: """
                    Shareable provides a user-friendly platform that allows you to discover, connect, and engage with like-minded individuals who share similar interests or have complementary skills. Here's how it works:
                    Shareable 提供一個易於使用的平台，讓您能夠發現、連結並與擁有相同興趣或互補技能的人互動。以下是運作方式：

                    1. Create an Account: Sign up for a Shareable account and create your profile. Tell us about your interests, skills, and what you're looking to share or learn.
                    建立帳號：註冊 Shareable 帳號並建立您的個人檔案。告訴我們您的興趣、技能，以及您希望分享或學習的內容。

                    2. Connect with Others: Explore the Shareable community and connect with individuals who share your passions or can offer valuable insights and resources.
                    與他人連結：探索 Shareable 社群，並與擁有相同熱情或能提供寶貴見解與資源的人建立聯繫。

                    3. Share Experiences: Share your expertise, experiences, or resources with others through posts, messages, or by offering specific services or items for sharing.
                    分享體驗：透過貼文、訊息，或提供特定服務與物品，與他人分享您的專業、經驗或資源。

                    4. Learn and Collaborate: Learn from others' expertise, engage in collaborative projects, or seek guidance and advice from the Shareable community.
                    學習與合作：從他人的專業中學習，參與合作專案，或在 Shareable 社群中尋求指導與建議。

                    5. Build Relationships: Cultivate meaningful connections, build relationships, and expand your network of like-minded individuals who support and inspire you.
                    建立關係：培養有意義的連結，建立關係，並擴展您的志同道合者網絡，讓彼此互相支持與啟發。
                    """
                ),
                LegalSection(
                    heading: "Contact Us\n聯絡我們",
                    body: "We value your feedback and are here to assist you. If you have any questions, suggestions, or need support regarding the Shareable app, please don't hesitate to contact our team.\n我們重視您的回饋，並隨時準備為您提供協助。如果您對 Shareable 應用程式有任何疑問、建議或需要支援，請隨時聯絡我們的團隊。\n\nEmail: shareable@cis.edu.hk\n電子郵件：shareable@cis.edu.hk"
                ),
            ]
        )
    }
}
