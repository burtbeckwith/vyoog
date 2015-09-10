grails.project.work.dir = 'target'

grails.project.dependency.resolver = "maven"
grails.project.dependency.resolution = {

	inherits 'global'
	log 'warn'

	repositories {
		grailsCentral()
		mavenLocal()
		mavenCentral()
	}

	plugins {
		compile ":mail:1.0.7"
		build(":release:3.1.1", ":rest-client-builder:2.1.1") {
			export = false
		}
	}
}
