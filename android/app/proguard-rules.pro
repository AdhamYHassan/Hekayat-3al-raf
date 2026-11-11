# Proguard / R8 rules for just_audio & just_audio_background
# In Release mode, R8 optimizer strips reflection calls and classes needed by ExoPlayer & MediaSession

# 1. Just Audio & Audio Service
-keep class com.ryanheise.just_audio.** { *; }
-dontwarn com.ryanheise.just_audio.**

-keep class com.ryanheise.audioservice.** { *; }
-dontwarn com.ryanheise.audioservice.**

# 2. ExoPlayer (The native audio engine behind just_audio)
-keep class com.google.android.exoplayer2.** { *; }
-dontwarn com.google.android.exoplayer2.**

# 3. AndroidX Media3 & Media Compat
-keep class androidx.media3.** { *; }
-dontwarn androidx.media3.**

# 4. Record & File Picker
-keep class com.llfbandit.record.** { *; }
-dontwarn com.llfbandit.record.**

-keep class com.mr.flutter.plugin.filepicker.** { *; }
-dontwarn com.mr.flutter.plugin.filepicker.**

# 5. Video Player & WebView
-keep class io.flutter.plugins.videoplayer.** { *; }
-dontwarn io.flutter.plugins.videoplayer.**

-keep class io.flutter.plugins.webviewflutter.** { *; }
-dontwarn io.flutter.plugins.webviewflutter.**

# 6. Flutter Secure Storage (KeyStore and Encrypted Preferences)
-keep class androidx.security.crypto.** { *; }
-dontwarn androidx.security.crypto.**

# 7. Media Compat & Support Libraries
-keep class android.support.v4.media.** { *; }
-dontwarn android.support.v4.media.**

-keep class androidx.media.** { *; }
-dontwarn androidx.media.**

