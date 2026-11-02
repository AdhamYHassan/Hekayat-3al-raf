# 📚 حكايات على الرف (Hekayat 3al Raf)

> **منصة التراث الشفهي والحكايات العربية الأصيلة — مبنية على أحدث معايير هندسة البرمجيات (Clean Architecture) ومحسنة لتشغيل فائق النعومة (60/120 FPS) على جميع الأجهزة بمقياس 1M+ Scale.**

---

## 🏛️ المعمارية البرمجية (System Architecture)

يعتمد التطبيق على معمارية **Clean Architecture** الصارمة مع مبادئ **SOLID**، حيث تنقسم الميزات (`Features`) إلى ثلاث طبقات معزولة:

```
[Presentation Layer]
  ├── Screens (Pure Rendering & Interactions)
  ├── Widgets (Isolated RepaintBoundaries & BlocSelectors)
  └── BLoC / Cubits (State Machine & Use Case Consumers only)
         │
         ▼ (Calls Interactors)
[Domain Layer]
  ├── Entities (Immutable Domain Models extending Equatable)
  ├── Use Cases (Single Responsibility Business Workflows)
  └── Repositories Contract (Abstract Interfaces)
         │
         ▼ (Dependency Inversion via GetIt)
[Data Layer]
  ├── Repositories Implementation (Caching, Error Mapping & Fallbacks)
  ├── Data Sources (Network APIs via Dio & Local Cache)
  └── DTOs / Models (Safe JSON Serialization)
```

---

## ⚡ أبرز الركائز الهندسية (Engineering Highlights)

### 1. مشغل الصوت الاحترافي (Background Audio Engine)
- **Zero-Latency Playback:** تشغيل فوري مع دعم كامل للتحكم في الصوت من مركز الإشعارات وشاشة القفل (`Lock Screen & Notification Center MediaSession`).
- **Smart Singleton with Virtual Resurrection:**
  - إيقاف وتحرير وحدات فك الترميز الأصلية (`Native Decoders`) تلقائياً بعد 5 دقائق من الخمول لتوفير طاقة البطارية والـ RAM.
  - استعادة الحالة وموضع التشغيل فور نقر المستخدم مرة أخرى بدون أي انهيار.
- **Background Stream Caching:** تحميل وحفظ المسار الصوتي تدريجياً في الذاكرة المؤقتة ليعمل 100% دون إنترنت في المرات القادمة.

### 2. محرر الحكايات الطويلة فائق الأداء (High-Performance Long-Form Editor)
- **Zero Keystroke Lag:** التخلص التام من تأخير الكتابة عبر فصل مدخلات لوحة المفاتيح عن شجرة الـ Widgets واستخدام **Debounced Autosave (1.2s)**.
- **وضع التركيز (Distraction-Free Zen Mode ✍️):** إمكانية فتح محرر ملء الشاشة للكتابة المستمرة بدون أي مشتتات بصرية.
- **Granular Leaf Metrics:** حساب عدد الكلمات وزمن القراءة التقديري عبر `ValueNotifier` معزول دون التسبب في إعادة رسم الحقول أو النصوص المحيطة (`RepaintBoundary`).

### 3. التفاعل والتصويت التفاؤلي (Optimistic UI Feedback)
- **انعدام زمن الاستجابة (Zero UI Latency):** تحديث أرقام الإعجاب وعدم الإعجاب وحالة الزر لحظياً عند النقر.
- **Graceful Rollback:** تراجع ناعم للحالة السابقة تلقائياً في حالة انقطاع اتصال الإنترنت دون إزعاج المستخدم.

---

## 📱 إعداد وتجهيز بيئات التشغيل (Platforms Setup)

### 🍏 iOS (100% Swift Package Manager)
- المشروع معد ليعمل **100% بواسطة Apple Swift Package Manager (SPM)** الصافي.
- **لا يحتاج إلى تثبيت CocoaPods نهائياً**، مما يقضي على مشاكل Ruby وأذونات النظام.
- متوافق مع نظام أبل لإدارة الحزم المعتمد في أحدث إصدارات Xcode و Flutter.

### 🤖 Android (Production & Low-End Optimization)
- **R8 / ProGuard Protection:** ملف `proguard-rules.pro` معد بدقة لحماية كلاسات المشغل والميديا (`com.ryanheise.audioservice`, `ExoPlayer`, `Media3`) من الحذف في وضع الإنتاج (`release`).
- **Foreground Service:** مهيأ كـ `mediaPlayback` وفقاً لأحدث سياسات متجر Google Play.

---

## 🚀 البدء والتشغيل (Getting Started)

### 1. تثبيت الاعتماديات:
```bash
flutter pub get
```

### 2. فحص جودة الكود:
```bash
flutter analyze lib/
```

### 3. تشغيل التطبيق (Debug):
```bash
flutter run
```

### 4. بناء نسخة الإنتاج (Android Release):
```bash
flutter build apk --release
```

---

## 📂 بنية المشروع (Project Structure)

```text
lib/
├── core/
│   ├── di/               # GetIt Service Locator Registration
│   ├── media/            # Audio & Video Native Services & Cubits
│   ├── network/          # Dio Factory, Failure contracts, Endpoints
│   ├── routing/          # GoRouter with custom smooth transitions
│   └── theming/          # Brand Colors & Typography
└── features/
    ├── home/             # Featured & Top Stories, Ambassadors BFF API
    ├── stories/          # Feed, Details, Audio Player, Optimistic Voting
    ├── ambassadors/      # Ambassadors Profiles & Cultural Archives
    └── submit_story/     # Multi-step Story Creator with Long-form Zen Editor
```
