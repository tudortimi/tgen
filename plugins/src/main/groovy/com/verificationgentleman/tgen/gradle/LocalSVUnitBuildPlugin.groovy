package com.verificationgentleman.tgen.gradle

import org.gradle.api.Action
import org.gradle.api.Plugin
import org.gradle.api.Project
import org.gradle.api.initialization.Settings
import org.gradle.api.internal.project.DefaultProject
import org.gradle.internal.classpath.DefaultClassPath

class LocalSVUnitBuildPlugin implements Plugin<Settings> {

    void apply(Settings settings) {
        settings.getRootProject().setName("svunit");

        settings.getGradle().rootProject(new Action<Project>() {
            @Override
            public void execute(Project project) {
                addInjectedPluginToClassPath(project);
                project.apply plugin: "com.verificationgentleman.gradle.hdvl.svunit-build"
            }
        });
    }

    private addInjectedPluginToClassPath(Project project) {
        project.buildscript {
            repositories {
                mavenLocal()
            }
            dependencies {
                classpath "com.verificationgentleman.gradle:gradle-hdvl:0.1.0-SNAPSHOT"
            }
        }

        // XXX WORKAROUND Setting the runtime classpath in the build script doesn't cause Gradle to
        // add the custom plugin to the injected build's classpath. Programmatic changes to
        // 'project.buildscript' also don't seem to have any effect. Adding the paths directly to
        // the class loader works.
        DefaultProject defaultProject = (DefaultProject) project
        defaultProject.classLoaderScope.local(DefaultClassPath.of(
            project.buildscript.configurations.classpath.files))
    }

}
