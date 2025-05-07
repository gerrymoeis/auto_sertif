plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.auto_sertif"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = "27.0.12077973" // Updated NDK version for plugin compatibility

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        applicationId = "com.autosertif.app"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = 21
        targetSdk = flutter.targetSdkVersion
        versionCode = 1
        versionName = "1.0.0"
    }

    signingConfigs {
        create("release") {
            // Anda perlu membuat keystore untuk release build
            // Gunakan perintah berikut untuk membuat keystore:
            // keytool -genkey -v -keystore auto_sertif.keystore -alias auto_sertif -keyalg RSA -keysize 2048 -validity 10000
            // Kemudian update path dan password di bawah ini
            // storeFile = file("../auto_sertif.keystore")
            // storePassword = "password"
            // keyAlias = "auto_sertif"
            // keyPassword = "password"
            
            // Untuk sementara, gunakan debug signing config
            storeFile = signingConfigs.getByName("debug").storeFile
            storePassword = signingConfigs.getByName("debug").storePassword
            keyAlias = signingConfigs.getByName("debug").keyAlias
            keyPassword = signingConfigs.getByName("debug").keyPassword
        }
    }
    
    buildTypes {
        release {
            // Aktifkan minify untuk optimasi
            isMinifyEnabled = true
            proguardFiles(getDefaultProguardFile("proguard-android-optimize.txt"), "proguard-rules.pro")
            signingConfig = signingConfigs.getByName("debug") // Gunakan debug signing untuk sementara
            
            // Tambahkan konfigurasi tambahan untuk release
            manifestPlaceholders["appName"] = "Auto Sertif"
        }
        debug {
            // Konfigurasi untuk debug build
            applicationIdSuffix = ".debug"
            versionNameSuffix = "-debug"
            manifestPlaceholders["appName"] = "Auto Sertif Debug"
        }
    }
}

dependencies {
    // Tambahkan Play Core library untuk mengatasi missing classes
    implementation("com.google.android.play:core:1.10.3")
}

flutter {
    source = "../.."
}
