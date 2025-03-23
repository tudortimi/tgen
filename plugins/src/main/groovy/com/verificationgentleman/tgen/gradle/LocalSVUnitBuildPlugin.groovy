package com.verificationgentleman.tgen.gradle

import org.gradle.api.Action
import org.gradle.api.Plugin
import org.gradle.api.Project
import org.gradle.api.initialization.Settings

class LocalSVUnitBuildPlugin implements Plugin<Settings> {

    void apply(Settings settings) {
        settings.getRootProject().setName("svunit");

        settings.getGradle().rootProject(new Action<Project>() {
            @Override
            public void execute(Project project) {
                project.apply plugin: "com.verificationgentleman.gradle.hdvl.svunit-build"
            }
        });
    }

}
