# 🎬 Video Subsystem Architecture & Performance Guide
### Platform: Hekayat 3al Raf (حكايات على الرف)

This document provides a comprehensive engineering breakdown of the **High-Performance Video Architecture** implemented in *Hekayat 3al Raf*. It details the design patterns, memory lifecycle, full-screen orientation restoration, network compatibility, and optimizations applied to meet locked **60/120 FPS performance on low-end hardware (2GB-3GB RAM) and 1M+ scale**.

---

## 🏛️ Architectural Overview (Clean Architecture & SOLID)

The video subsystem mirrors the clean boundaries established in our audio architecture, keeping the UI completely free of low-level decoder complexities:

```
[Presentation Layer]
   └── StoryVideoPlayerCard (Local Scoped Component)
   └── FullScreenVideoScreen (Immersive Sticky Landscape Screen)
   └── VideoPlayerCubit (State Machine & Overlay Controls Timer)
          │
          ▼ (Interactors / Abstractions)
[Domain / Core Contract]
   └── IVideoPlayerService (Pure Abstract Interface)
   └── VideoPlaybackState (Equatable Immutable UI State)
          │
          ▼ (Dependency Inversion - DI via getIt Factory)
[Data / Infrastructure Layer]
   └── DefaultVideoPlayerService (Implementation via video_player)
          ├── Single-Instance GPU Surface Allocator
          ├── ValueNotifier to Stream Adapter
          └── Auto-Disposal & Memory Leak Prevention Engine
```

---

## ⚡ Core Engineering Pillars & Optimizations

### 1. Local Scoped Lifecycle vs. Global Singleton (Why Factory in DI?)
* **The Dilemma:**
  - Audio playback must persist across screens (hence a `LazySingleton`).
  - Video decoding, however, consumes heavy **Native GPU Texture Surfaces (VRAM)** and hardware decoding pipelines.
  - Keeping a video controller open when navigating away triggers the **Android Low-Memory Killer (OOM)** on 2GB RAM budget devices (e.g. Huawei GR5 / 2015-era hardware).
* **The Architectural Solution:**
  - `DefaultVideoPlayerService` and `VideoPlayerCubit` are registered as **`Factory`** in `getIt`.
  - The cubit is initialized **locally** inside `StoryVideoPlayerCard` via `BlocProvider(create: ...)`.
  - When the user leaves the story details screen or scrolls past the card, the widget is unmounted from the element tree, automatically invoking `cubit.close()`.
  - The cubit guarantees immediate execution of `_controller.dispose()`, freeing the native hardware surface and returning VRAM to the operating system immediately.

### 2. Audio/Video Coexistence (Single Source of Truth)
* **The Conflict:** Uncontrolled audio overlap when a user plays a video narrative while an audio narrative is active in the background.
* **The Solution:**
  - `VideoPlayerCubit` injects `IAudioPlayerService` via dependency injection.
  - Before starting video playback (`play()` or `togglePlay()`), the cubit automatically calls:
    ```dart
    await _audioService?.pause();
    ```
  - Ensures absolute zero acoustic collision without tight coupling between UI widgets.

### 3. Bulletproof Fullscreen & Dual-Platform Orientation Management
* **The iOS 16/17 Orientation Bug (`UISceneErrorDomain Code=101`):**
  - Modern iOS versions reject dynamic orientation changes if the root window controller restricts allowed orientations.
  - **The Native Fix:** Added dynamic support via `AppDelegate.swift` allowing `.allButUpsideDown` at the window level, while Flutter locks the app to `portraitUp` globally.
* **The Landscape ScreenUtil Skewing Bug:**
  - In landscape mode, using scaled units (`.w` / `.h`) distorts circular buttons into squashed ovals because the width and height axes flip.
  - **The Fix:** Full-screen overlay controls use **fixed geometric pixels** (`width: 68, height: 68` with `BorderRadius.circular(35)`), guaranteeing a 1:1 true circle across all phone models.
* **Orientation Restoration Guarantee:**
  - `FullScreenVideoScreen` wraps the tree in `PopScope(canPop: false)`.
  - Exiting full screen (via the UI button, device back gesture, or system back button) synchronously calls:
    ```dart
    await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    ```
  - Prevents the dreaded "App stuck in landscape" bug.

### 4. Legacy Device Compatibility & Network Security Config
* **The Android 7 SSL Issue (`CertPathValidatorException / Trust anchor not found`):**
  - Older devices (like Huawei GR5 2015 / Android 7) have outdated system certificate authorities.
  - **The Fix:** Configured `network_security_config.xml` with system and user trust anchors and enabled it in `AndroidManifest.xml`.
  - Prevents SSL handshake failures when streaming from modern HTTPS endpoints.

### 5. Heritage Glassmorphic UI & 120 FPS Interaction
* **Hit-Test Isolation:** Separate tap handling for the background container (`HitTestBehavior.opaque` for show/hide controls) and the center play button (`Material + InkWell`), eliminating gesture swallowing.
* **Frosted Glass Styling:** Center controls combine `BackdropFilter(sigma: 10)`, `primaryDark` translucency, and heritage gold accents (`ColorManager.gold` & `goldLight`).
* **Auto-Hiding Controls:** Overlay controls fade out smoothly after 3 seconds of user inactivity, automatically reappearing upon a single tap.
* **Anti-Jitter Slider:** Smooth dragging decoupled from asynchronous native position streams, dispatching `seek()` only upon drop (`onChangeEnd`).

---

## 🛠️ Diagnostic Log Signatures

When debugging video playback, observe these structured console tags:
* `[VideoPlayer] Initializing video: <URL>`
* `[VideoPlayer] Initialized successfully. Duration: <Duration>, AspectRatio: <Ratio>`
* `[VideoPlayer] Center Play clicked`
* `[VideoPlayer] ERROR initializing video: <Exception>`

