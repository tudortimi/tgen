package com.verificationgentleman.tgen.gradle

import org.gradle.api.Plugin
import org.gradle.api.initialization.Settings

class LocalSVUnitBuildPlugin implements Plugin<Settings> {

    void apply(Settings settings) {
        settings.apply plugin: "com.verificationgentleman.gradle.hdvl.svunit-build"
    }

}
