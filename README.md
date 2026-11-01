# 📜 حكايات على الرف (Hekayat 3al Raf)

> **منصة توثيق وأرشفة التاريخ الشفاهي والتراث الثقافي الحي.**

تطبيق Flutter معماري متطور ومصمم للعمل بمعدل **60/120 FPS مقفل** على كافة الهواتف (بما فيها أجهزة أندرويد الاقتصادية 2GB-3GB RAM وهواتف iPhone القديمة) لخدمة أكثر من مليون مستخدم.

---

## 🏗️ المعمارية والأنماط الهندسية (Architecture & Engineering)

يتبع المشروع بدقة مبادئ **Clean Architecture** الصارمة مع فصل الطبقات:
* **Presentation Layer:** واجهات مستخدم نقية خالية من الـ Business Logic، تدار حصرياً بواسطة **Cubit / Bloc** ومدعومة بـ `BlocSelector` و `RepaintBoundary` لتحقيق أعلى أداء لعرض الفريمات.
* **Domain Layer:** نوات بيزنس نقية، Use Cases مستقلة تماماً، و Entities محصنة ضد التغييرات الخارجية ومحمية بـ `Equatable`.
* **Data Layer:** تطبيق نمط الـ Repository Pattern، إدارة الـ Data Sources (Remote / Local / Mock)، وعزل استثناءات الشبكة.

---

## 🎧 نظام الصوت المتطور (Audio Subsystem Architecture)

تم بناء نظام تشغيل الصوت في التطبيق ليعمل كـ **Production-Grade Media Engine** مطابق لمعايير تطبيقات مثل Spotify و Audible:

* **Smart Singleton with Virtual Lazy Resurrection:** إيقاف وتحرير محركات الصوت الأصلية (Native Decoders) تلقائياً عند خمول المستخدم لأكثر من 5 دقائق لتوفير البطارية والذاكرة، مع استعادة موضع الصوت والتراك فوراً وبدون أي كراش عند العودة للتشغيل.
* **Dual-Stream Zero-Latency Audio Caching:** تشغيل لحظي للصوت من الإنترنت مع كتابة وتخزين الملف بالتوازي في مجلد الكاش المؤقت لضمان تشغيله أوفلاين في المرات القادمة وتوفير 100% من باقة المستخدم.
* **Audio Focus & Becoming Noisy Handling:** إيقاف التشغيل فوراً عند فصل سماعات الرأس أو الـ AirPods لمنع الإحراج في الأماكن العامة، مع استئناف الصوت تلقائياً بعد انتهاء المكالمات الهاتفية.
* **Lock Screen & Media Notification:** تكامل كامل مع `MPNowPlayingInfoCenter` على iOS و `ForegroundService (mediaPlayback)` على Android.
* **Granular 120 FPS Rebuilds:** عزل شريط التمرير (Slider) عن الكارت الخارجي بواسطة `BlocSelector` و `buildWhen` الدقيقة.

> 📖 **للاطلاع على التوثيق الهندسي والمعماري الكامل لنظام الصوت:**  
> يرجى مراجعة [Audio Architecture Guide](docs/AUDIO_ARCHITECTURE.md).

---

## 🎬 نظام الفيديو السينمائي المتطور (Video Subsystem Architecture)

تم بناء نظام تشغيل الفيديو ليعمل بكفاءة فائقة على أجهزة الـ 2GB RAM وبدون استنزاف كارت الشاشة (VRAM):

* **Single-Instance GPU Factory & Auto-Disposal:** إدارة صارمة لذاكرة الـ Texture Surface، حيث يتم تحرير معالج الفيديو وموارده فور مغادرة الشاشة لمنع الـ Out-Of-Memory (OOM) Crashes.
* **Audio/Video Coexistence:** إيقاف مشغل الصوت في الخلفية تلقائياً عند تشغيل أي مقطع فيديو لمنع تداخل الأصوات.
* **Bulletproof Fullscreen & Dual-Platform Rotation:** دعم كامل لوضع الشاشة الكاملة الأفقي (Landscape) مع حماية ضد أخطاء iOS 16 (`UISceneErrorDomain Code=101`)، واستعادة الوضع الرأسي (Portrait) بشكل متزامن وآمن عبر `PopScope`.
* **Legacy Device & Network Compatibility:** إضافة `network_security_config.xml` لحل مشكلات الشهادات منتهية الصلاحية (SSL Handshake) على هواتف أندرويد القديمة مثل Huawei GR5.
* **Heritage Glassmorphism UI:** تصميم أزرار زجاجية فخمة باللون الماروني والذهبي، مع أبعاد دائرية نقية 1:1 في الوضع الأفقي، وخاصية الإخفاء التلقائي بعد 3 ثوانٍ.

> 📖 **للاطلاع على التوثيق الهندسي والمعماري الكامل لنظام الفيديو:**  
> يرجى مراجعة [Video Architecture Guide](docs/VIDEO_ARCHITECTURE.md).

---

## 📱 التقنيات المستخدمة (Tech Stack)

* **Framework:** Flutter 3.x (Dart 3+)
* **State Management:** `flutter_bloc` / `bloc` (No Freezed, No code generation)
* **Service Locator:** `get_it`
* **Routing:** `go_router`
* **Media & Playback:** `just_audio`, `just_audio_background`, `audio_session`, `video_player`
* **Responsive Layout:** `flutter_screenutil`
* **Typography:** `google_fonts` (Alexandria, IBM Plex Sans Arabic, Aref Ruqaa)
* **Localization:** `easy_localization` (دعم عربي وإنجليزي بدون أي Hardcoded Strings)
