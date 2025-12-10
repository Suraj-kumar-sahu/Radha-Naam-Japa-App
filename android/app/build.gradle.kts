// android/app/build.gradle.kts

plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
    // Apply Google services plugin (REQUIRED for google-services.json)
    id("com.google.gms.google-services")
}

android {
    namespace = "com.example.radha_naam_japa"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    defaultConfig {
        applicationId = "com.example.radha_naam_japa"
        minSdk = flutter.minSdkVersion               // REQUIRED for Firebase Auth
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug") // For now
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    // --- Firebase BoM (manages compatible versions automatically)
    // implementation(platform("com.google.firebase:firebase-bom:34.6.0"))

    // --- Firebase SDKs you want (NO versions needed when using BoM)
    implementation("com.google.firebase:firebase-analytics-ktx:22.1.2")
    implementation("com.google.firebase:firebase-auth-ktx:23.1.0")
    implementation("com.google.firebase:firebase-analytics:22.1.2")

    // (Optional) If you later use Firestore, add:
    // implementation("com.google.firebase:firebase-firestore-ktx")

    // (Optional) If you later use Messaging:
    // implementation("com.google.firebase:firebase-messaging-ktx")
}
