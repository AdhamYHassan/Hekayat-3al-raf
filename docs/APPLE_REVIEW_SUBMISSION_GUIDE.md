# دليل تجهيز مراجعة أبل (App Store Review Submission Guide)
## تطبيق: حكايات على الرف (Hekayat 3al Raf)

---

### 1. بيانات الحساب التجريبي المخصص لمراجع أبل (Sign-In Information)
> [!IMPORTANT]
> أبل ترفض التطبيقات فوراً إذا كان هناك تسجيل دخول ولا يوجد حساب اختبار نشط.

* **User Name / Email:** `apple_reviewer@hekayat3alraf.com` (أو إيميل الـ Demo الحالي)
* **Password:** `AppleReviewer2026!`
* **Notes:**
  > "Reviewer can also use the application completely without logging in by browsing the feed, listening to stories, and viewing ambassadors. Login is only required when submitting a story, voting, or submitting an inquiry."

---

### 2. ملاحظات المراجعة المكتوبة (App Review Notes / Review Notes Box)
انسخ هذا النص بالإنجليزية وضعه في حقل **Review Notes** في App Store Connect:

```text
Dear Apple App Review Team,

Welcome to "Hekayat 3al Raf" (حكايات على الرف).
Our platform is a cultural Arabic storytelling app that allows users to discover, read, and listen to authentic folk stories, historical documents, and cultural heritage, as well as interact with cultural ambassadors.

Key Features & Permissions Usage:
1. Audio Background Playback (UIBackgroundModes -> audio):
   The app provides an integrated audio player for voice-narrated stories. Users can continue listening to long-form cultural audio narratives while the app is in the background or when the device screen is locked. Remote controls in Control Center and lock screen are fully supported.

2. Microphone Permission (NSMicrophoneUsageDescription):
   Used strictly when a user chooses to record their own voice narration in the "Submit Story" flow (Audio Story option). Audio is captured only while the user actively holds/taps the record button.

3. Photo Library & Camera Permissions (NSPhotoLibraryUsageDescription & NSCameraUsageDescription):
   Used strictly for:
   - Selecting or capturing a cover thumbnail for user-submitted stories.
   - Uploading a profile avatar picture in the "Edit Profile" screen.
   - Attaching video stories from user gallery.

4. Account Deletion (Guideline 5.1.1(v)):
   Users can initiate and complete full permanent account deletion directly within the app by navigating to: More (المزيد) -> Delete Account (حذف الحساب).

Demo Credentials:
- Email: [YOUR_TEST_EMAIL]
- Password: [YOUR_TEST_PASSWORD]

A walkthrough demo video demonstrating background audio, story narration, and permissions is available here:
[LINK_TO_UNLISTED_YOUTUBE_OR_DRIVE_VIDEO]

Thank you for your review. Please let us know if any further information is needed.
```

---

### 3. وصف التطبيق (App Description)

#### بالعربية (Arabic):
```text
منصة "حكايات على الرف" هي ملتقى الحكايات والذكريات والتراث الإنساني.
نفتح الأبواب لكل من يملك قصة تستحق أن تُروى، لتوثيق الحكايات الشفاهية، والوثائق القديمة، واللحظات التاريخية بصوت أصحابها.

أهم المميزات:
• استمع واقرأ: تصفح مكتبة غنية من الحكايات المكتوبة، والتسجيلات الصوتية النقية، ومقاطع الفيديو، والوثائق النادرة.
• استماع في الخلفية: استمتع بالاستماع للروايات الصوتية بسلاسة أثناء تصفح هاتفك أو عند قفل الشاشة.
• سفراء الحكايات: تعرف على نخبة من الكتاب وصناع المحتوى وسفراء التراث، واطرح أسئلتك وتواصل معهم مباشرة.
• احكي حكايتك: شارك حكايتك الخاصة وسجل صوتك أو ارفع وثائقك لتصل إلى آلاف المهتمين بعد مراجعتها وتوثيقها.
• خصوصية وتحكم كامل: خيارات متعددة لنشر الحكايات باسمك أو بهوية مستعارة مع تحكم كامل في حسابك وبياناتك.
```

#### بالإنجليزية (English):
```text
"Hekayat 3al Raf" is a cultural platform dedicated to archiving and celebrating Arabic human stories, oral heritage, historical documents, and authentic memories.

Key Features:
• Listen & Read: Explore a rich repository of written stories, audio recordings, video narratives, and historical documents.
• Background Audio Player: Enjoy listening to audio stories with background playback and lock-screen controls.
• Cultural Ambassadors: Connect with cultural figures, writers, and narrators, ask questions, and explore their curated collections.
• Share Your Story: Contribute your own heritage, record voice narrations, or upload historic documents easily.
• Privacy & Control: Comprehensive profile management, message tracking, and full privacy compliance.
```

---

### 4. ما يجب تصويره في الفيديو التجريبي (Demo Video Checklist)
أبل تطلب أحياناً فيديو (خصوصاً بسبب الـ Background Audio والـ Microphone). لتجنب الرفض من المرة الأولى، صوّر فيديو مدته من **1:30 إلى 2:30 دقيقة** يغطي الآتي:

1. **الاستماع في الخلفية (Background Audio) - أهم نقطة:**
   - افتح قصة صوتية واضغط تشغيل (Play).
   - اخرج إلى الشاشة الرئيسية للآيفون أو افتح تطبيقاً آخر وبيّن أن الصوت مستمر في العمل.
   - اسحب الـ Control Center من أعلى وبيّن الـ Audio Player Widget وشغال عليه الـ Play/Pause.
   - اقفل شاشة الآيفون واضغط عليها ليظهر الـ Lock Screen Player واضغط Pause ثم Play.
2. **إذن الميكروفون (Microphone Permission):**
   - ادخل على تبويب "احكي حكايتك" (Submit).
   - اختر "حكاية صوتية" (Audio Story).
   - اضغط على زر التسجيل ليظهر تنبيه نظام iOS بالإنجليزية/العربية لطلب إذن الميكروفون واضغط "سماح" (Allow).
   - سجل ثانيتين واعمل إيقاف واستمع للتسجيل.
3. **إذن الصور / الكاميرا (Photo / Camera Permission):**
   - من نفس الشاشة أو من شاشة "الملف الشخصي -> تعديل الملف الشخصي".
   - اضغط على صورة البروفايل لتغيير الصورة وبيّن ظهور رسالة إذن الوصول للصور.
4. **تصفح السفراء والرسائل:**
   - ادخل على تبويب "السفراء" واستعرض كارت السفير.
   - ادخل على "الملف الشخصي -> رسايلي" وافتح كارت رسالة بها رد الإدارة.
5. **حذف الحساب (Account Deletion):**
   - ادخل على "المزيد -> حذف الحساب" وأظهر ظهور الدايلوج الخاص بطلب تأكيد الحذف وتأكيد الباسورد (دون الحاجة لتنفيذ الحذف فعلياً في الفيديو).

> [!TIP]
> ارفع الفيديو على **YouTube (Unlisted)** أو **Google Drive (Anyone with the link can view)**، وضع الرابط في خانة **Review Notes**.
