plugins {
    id("com.android.application")
    id("org.jetbrains.kotlin.android") version "2.0.0" // Update from 1.8.22 to 2.0.0 or newer
    id("com.google.gms.google-services")
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.psg_leaders_book"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = "27.0.12077973"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    defaultConfig {
        applicationId = "com.example.psg_leaders_book"
        minSdk = 23 // Changed from 21 to 23
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")
            proguardFiles(getDefaultProguardFile("proguard-android-optimize.txt"), "proguard-rules.pro")
        }
    }
}

dependencies {
    // Update these versions to match your Kotlin plugin version
    implementation("org.jetbrains.kotlin:kotlin-stdlib-jdk8:2.0.0")  // Update to 2.0.0
    implementation("org.jetbrains.kotlin:kotlin-stdlib-jdk7:2.0.0")  // Update to 2.0.0  
    implementation("org.jetbrains.kotlin:kotlin-stdlib:2.0.0")       // Update to 2.0.0
    implementation(platform("com.google.firebase:firebase-bom:32.7.4"))
    implementation("com.google.firebase:firebase-auth")
    implementation("com.google.firebase:firebase-firestore")
}

flutter {
    source = "../.."
}