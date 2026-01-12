allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
subprojects {
    project.evaluationDependsOn(":app")
}

subprojects {
    if (project.name == "on_audio_query_android") {
        val fixOnAudioQuery = {
            val android = project.extensions.findByName("android")
            if (android != null) {
                try {
                    val setNamespace = android.javaClass.getMethod("setNamespace", String::class.java)
                    setNamespace.invoke(android, "com.lucasjosino.on_audio_query")
                    println("Fixed namespace for on_audio_query_android")
                } catch (e: Exception) {
                    println("Failed to fix namespace for on_audio_query_android: $e")
                }
            }
            
            project.tasks.all {
                if (this::class.java.name.contains("KotlinCompile")) {
                     try {
                        val getKotlinOptions = this::class.java.getMethod("getKotlinOptions")
                        val options = getKotlinOptions.invoke(this)
                        val setJvmTarget = options::class.java.getMethod("setJvmTarget", String::class.java)
                        setJvmTarget.invoke(options, "1.8")
                        println("Fixed JVM target for ${this.name}")
                     } catch (e: Exception) {
                        // Ignore
                     }
                }
            }
        }

        if (project.state.executed) {
            fixOnAudioQuery()
        } else {
            project.afterEvaluate {
                fixOnAudioQuery()
            }
        }
    }
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
