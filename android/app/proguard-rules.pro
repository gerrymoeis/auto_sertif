# Flutter specific rules
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }

# Flutter embedding
-keep class androidx.lifecycle.** { *; }
-keep class io.flutter.embedding.** { *; }
-keep class io.flutter.embedding.android.** { *; }
-keep class io.flutter.embedding.engine.** { *; }
-keep class io.flutter.plugin.common.** { *; }

# Flutter plugins
-keep class io.flutter.plugins.imagepicker.** { *; }
-keep class io.flutter.plugins.pathprovider.** { *; }
-keep class io.flutter.plugins.flutter_plugin_android_lifecycle.** { *; }

# Keep native methods
-keepclassmembers class * {
    native <methods>;
}

# Keep Serializable classes and their members
-keepclassmembers class * implements java.io.Serializable {
    static final long serialVersionUID;
    private static final java.io.ObjectStreamField[] serialPersistentFields;
    private void writeObject(java.io.ObjectOutputStream);
    private void readObject(java.io.ObjectInputStream);
    java.lang.Object writeReplace();
    java.lang.Object readResolve();
}

# Keep the BuildConfig
-keep class com.autosertif.app.BuildConfig { *; }

# Keep the support library
-keep class androidx.** { *; }
-keep interface androidx.** { *; }

# Keep specific libraries used in the project
-keep class com.google.android.material.** { *; }

# Play Core library
-keep class com.google.android.play.core.splitcompat.SplitCompatApplication { *; }
-keep class com.google.android.play.core.splitinstall.SplitInstallException { *; }
-keep class com.google.android.play.core.splitinstall.SplitInstallSessionState { *; }
-keep class com.google.android.play.core.tasks.OnFailureListener { *; }
-keep class com.google.android.play.core.tasks.OnSuccessListener { *; }
-keep class com.google.android.play.core.tasks.Task { *; }
-keep class com.google.android.play.core.** { *; }
