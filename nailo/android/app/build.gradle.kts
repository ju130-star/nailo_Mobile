plugins {
    id("com.android.application")
    // START: FlutterFire Configuration
    id("com.google.gms.google-services")
    // END: FlutterFire Configuration
    id("kotlin-android")
    // O plugin Flutter deve vir depois do Android e Kotlin
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.nailo"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    // ⚙️ Opções de compatibilidade e desugaring
    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
        isCoreLibraryDesugaringEnabled = true // 👈 essencial para corrigir o erro
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        applicationId = "com.example.nailo"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
        multiDexEnabled = true // 👈 útil para apps grandes com muitas libs
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}

// ⚡ Dependências adicionais
dependencies {
    // Necessário para o desugaring (corrige erro do flutter_local_notifications)
    add("coreLibraryDesugaring", "com.android.tools:desugar_jdk_libs:2.0.4")

    // Garante compatibilidade com APIs Java modernas
    implementation("org.jetbrains.kotlin:kotlin-stdlib-jdk8")
}
