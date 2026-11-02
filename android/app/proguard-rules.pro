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

-keep class android.support.v4.media.** { *; }
-dontwarn android.support.v4.media.**

-keep class androidx.media.** { *; }
-dontwarn androidx.media.**

