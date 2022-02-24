# jaws-admin-gui [![Java CI with Gradle](https://github.com/JeffersonLab/jaws-admin-gui/actions/workflows/gradle.yml/badge.svg)](https://github.com/JeffersonLab/jaws-admin-gui/actions/workflows/gradle.yml) [![Docker](https://img.shields.io/docker/v/slominskir/jaws-admin-gui?sort=semver&label=DockerHub)](https://hub.docker.com/r/slominskir/jaws-admin-gui)
Web Admin interface for [JAWS](https://github.com/JeffersonLab/jaws) to manage alarm registration classes and instances.

<p>
<a href="#"><img src="https://raw.githubusercontent.com/JeffersonLab/jaws-web-admin/master/Screenshot.png"/></a>     
</p>

---
 - [Overview](https://github.com/JeffersonLab/jaws-admin-gui#overview)
 - [Usage](https://github.com/JeffersonLab/jaws-admin-gui#usage)
    - [Quick Start with Compose](https://github.com/JeffersonLab/jaws-admin-gui#quick-start-with-compose) 
    - [Install](https://github.com/JeffersonLab/jaws-admin-gui#install)
 - [Configure](https://github.com/JeffersonLab/jaws-admin-gui#configure)
 - [Build](https://github.com/JeffersonLab/jaws-admin-gui#build)
 - [See Also](https://github.com/JeffersonLab/jaws-admin-gui#see-also)
---

## Overview
Alarm system registration data consists of locations, categories, classes, and instances.  Collectively the data forms effective registrations.

## Usage

### Quick Start with Compose
1. Grab project
```
git clone https://github.com/JeffersonLab/jaws-admin-gui
cd jaws-admin-gui
```
2. Launch Docker
```
docker compose up
```
3. Launch web browser
```
http://localhost:8080/jaws-admin-gui
```
**Note**: The docker-compose services require significant system resources - tested with 4 CPUs and 4GB memory.

**See**: [Docker Compose Strategy](https://gist.github.com/slominskir/a7da801e8259f5974c978f9c3091d52c)

### Install
   1. Download [Wildfly 26](https://www.wildfly.org/downloads/)
   1. Build [jaws-admin-gui.war](https://github.com/JeffersonLab/jaws-admin-gui#build) and deploy it to Wildfly
   1. Navigate your web browser to localhost:8080/jaws-admin-gui


## Configure
The following environment variables are required:

| Name | Description |
|----------|---------|
| BOOTSTRAP_SERVERS | Host and port pair pointing to a Kafka server to bootstrap the client connection to a Kafka Cluser; example: `kafka:9092` |
| SCHEMA_REGISTRY | URL to Confluent Schema Registry; example: `http://registry:8081` |

## Build
This [Java 17](https://adoptium.net/) project (compiled to Java 11 bytecode) uses the [Gradle 7](https://gradle.org/) build tool to automatically download dependencies and build the project from source:

```
git clone https://github.com/JeffersonLab/jaws-admin-gui
cd jaws-admin-gui
gradlew build
```
**Note**: If you do not already have Gradle installed, it will be installed automatically by the wrapper script included in the source

**Note for JLab On-Site Users**: Jefferson Lab has an intercepting [proxy](https://gist.github.com/slominskir/92c25a033db93a90184a5994e71d0b78)

**Note**: The dependency jars (except Java EE 8 jars required to be available in the server) are included in the war file that is generated by the build by default, but you can optionally exclude them (if you intend to install them into the application server) with the flag -Pprovided like so:
```
gradlew -Pprovided build
```

**See**: [Docker Development Quick Reference](https://gist.github.com/slominskir/a7da801e8259f5974c978f9c3091d52c#development-quick-reference)

## See Also
- [JLab alarm data](https://github.com/JeffersonLab/alarms)
