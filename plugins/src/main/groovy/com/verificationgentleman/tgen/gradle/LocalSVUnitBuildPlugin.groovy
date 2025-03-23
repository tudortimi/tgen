package com.verificationgentleman.tgen.gradle

import org.gradle.api.Action
import org.gradle.api.Plugin
import org.gradle.api.Project
import org.gradle.api.initialization.Settings

class LocalSVUnitBuildPlugin implements Plugin<Settings> {

    void apply(Settings settings) {
        settings.gradle.rootProject {
            apply plugin: 'com.verificationgentleman.gradle.hdvl.svunit-build'
        }
    }

}
