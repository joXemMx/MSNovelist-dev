@rem
@rem Copyright 2015 the original author or authors.
@rem
@rem Licensed under the Apache License, Version 2.0 (the "License");
@rem you may not use this file except in compliance with the License.
@rem You may obtain a copy of the License at
@rem
@rem      https://www.apache.org/licenses/LICENSE-2.0
@rem
@rem Unless required by applicable law or agreed to in writing, software
@rem distributed under the License is distributed on an "AS IS" BASIS,
@rem WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
@rem See the License for the specific language governing permissions and
@rem limitations under the License.
@rem

@if "%DEBUG%" == "" @echo off
@rem ##########################################################################
@rem
@rem  fingerprinter_cli startup script for Windows
@rem
@rem ##########################################################################

@rem Set local scope for the variables with windows NT shell
if "%OS%"=="Windows_NT" setlocal

set DIRNAME=%~dp0
if "%DIRNAME%" == "" set DIRNAME=.
set APP_BASE_NAME=%~n0
set APP_HOME=%DIRNAME%..

@rem Resolve any "." and ".." in APP_HOME to make it shorter.
for %%i in ("%APP_HOME%") do set APP_HOME=%%~fi

@rem Add default JVM options here. You can also use JAVA_OPTS and FINGERPRINTER_CLI_OPTS to pass JVM options to this script.
set DEFAULT_JVM_OPTS=

@rem Find java.exe
if defined JAVA_HOME goto findJavaFromJavaHome

set JAVA_EXE=java.exe
%JAVA_EXE% -version >NUL 2>&1
if "%ERRORLEVEL%" == "0" goto execute

echo.
echo ERROR: JAVA_HOME is not set and no 'java' command could be found in your PATH.
echo.
echo Please set the JAVA_HOME variable in your environment to match the
echo location of your Java installation.

goto fail

:findJavaFromJavaHome
set JAVA_HOME=%JAVA_HOME:"=%
set JAVA_EXE=%JAVA_HOME%/bin/java.exe

if exist "%JAVA_EXE%" goto execute

echo.
echo ERROR: JAVA_HOME is set to an invalid directory: %JAVA_HOME%
echo.
echo Please set the JAVA_HOME variable in your environment to match the
echo location of your Java installation.

goto fail

:execute
@rem Setup the command line

set CLASSPATH=%APP_HOME%\lib\fingerprinter_cli-2.8.0-SNAPSHOT.jar;%APP_HOME%\lib\fingerprinter_oss-2.8.0-SNAPSHOT.jar;%APP_HOME%\lib\chemdb_sql_oss-2.8.0-SNAPSHOT.jar;%APP_HOME%\lib\chemdb_utils_oss-2.8.0-SNAPSHOT.jar;%APP_HOME%\lib\chemical_db_oss-2.8.0-SNAPSHOT.jar;%APP_HOME%\lib\fingerid_base_oss-2.8.0-SNAPSHOT.jar;%APP_HOME%\lib\blob-storage-4.14.0-SNAPSHOT.jar;%APP_HOME%\lib\io-4.14.0-SNAPSHOT.jar;%APP_HOME%\lib\sirius_api-4.14.0-SNAPSHOT.jar;%APP_HOME%\lib\sirius_isotopes-4.14.0-SNAPSHOT.jar;%APP_HOME%\lib\tree_motif_search-4.14.0-SNAPSHOT.jar;%APP_HOME%\lib\fragmentation_tree_construction-4.14.0-SNAPSHOT.jar;%APP_HOME%\lib\isotope_pattern_analysis-4.14.0-SNAPSHOT.jar;%APP_HOME%\lib\preprocessing-4.14.0-SNAPSHOT.jar;%APP_HOME%\lib\lcms-4.14.0-SNAPSHOT.jar;%APP_HOME%\lib\elgordo-4.14.0-SNAPSHOT.jar;%APP_HOME%\lib\mass_decomposer-4.14.0-SNAPSHOT.jar;%APP_HOME%\lib\spectral_alignment-4.14.0-SNAPSHOT.jar;%APP_HOME%\lib\Recalibration-1.0.jar;%APP_HOME%\lib\chemistry_base-4.14.0-SNAPSHOT.jar;%APP_HOME%\lib\utils-4.14.0-SNAPSHOT.jar;%APP_HOME%\lib\annotations-4.14.0-SNAPSHOT.jar;%APP_HOME%\lib\jjobs-core-0.9.35.jar;%APP_HOME%\lib\minio-8.4.6.jar;%APP_HOME%\lib\okhttp-4.10.0.jar;%APP_HOME%\lib\okio-jvm-3.0.0.jar;%APP_HOME%\lib\kotlin-stdlib-jdk8-1.5.31.jar;%APP_HOME%\lib\kotlin-stdlib-jdk7-1.5.31.jar;%APP_HOME%\lib\kotlin-stdlib-1.6.20.jar;%APP_HOME%\lib\annotations-23.0.0.jar;%APP_HOME%\lib\core-3.1.0.jar;%APP_HOME%\lib\google-cloud-storage-1.118.0.jar;%APP_HOME%\lib\guava-31.1-jre.jar;%APP_HOME%\lib\commons-configuration2-2.8.0.jar;%APP_HOME%\lib\commons-text-1.9.jar;%APP_HOME%\lib\cdk-bundle-2.8.jar;%APP_HOME%\lib\cdk-qsarcml-2.8.jar;%APP_HOME%\lib\cdk-libiomd-2.8.jar;%APP_HOME%\lib\cdk-pdbcml-2.8.jar;%APP_HOME%\lib\cdk-libiocml-2.8.jar;%APP_HOME%\lib\cmlxom-4.3.jar;%APP_HOME%\lib\euclid-2.3.jar;%APP_HOME%\lib\commons-lang3-3.12.0.jar;%APP_HOME%\lib\xxindex-0.23.jar;%APP_HOME%\lib\commons-io-2.11.0.jar;%APP_HOME%\lib\httpclient5-5.1.3.jar;%APP_HOME%\lib\slf4j-api-1.7.36.jar;%APP_HOME%\lib\jewelcli-0.8.9.jar;%APP_HOME%\lib\failureaccess-1.0.1.jar;%APP_HOME%\lib\listenablefuture-9999.0-empty-to-avoid-conflict-with-guava.jar;%APP_HOME%\lib\jsr305-3.0.2.jar;%APP_HOME%\lib\checker-qual-3.12.0.jar;%APP_HOME%\lib\error_prone_annotations-2.11.0.jar;%APP_HOME%\lib\j2objc-annotations-1.3.jar;%APP_HOME%\lib\cdk-qsarmolecular-2.8.jar;%APP_HOME%\lib\cdk-model-2.8.jar;%APP_HOME%\lib\cdk-fingerprint-2.8.jar;%APP_HOME%\lib\cdk-qsaratomic-2.8.jar;%APP_HOME%\lib\cdk-legacy-2.8.jar;%APP_HOME%\lib\cdk-extra-2.8.jar;%APP_HOME%\lib\cdk-datadebug-2.8.jar;%APP_HOME%\lib\cdk-qsarprotein-2.8.jar;%APP_HOME%\lib\cdk-pdb-2.8.jar;%APP_HOME%\lib\cdk-builder3d-2.8.jar;%APP_HOME%\lib\cdk-pcore-2.8.jar;%APP_HOME%\lib\cdk-data-2.8.jar;%APP_HOME%\lib\cdk-tautomer-2.8.jar;%APP_HOME%\lib\cdk-inchi-2.8.jar;%APP_HOME%\lib\cdk-fragment-2.8.jar;%APP_HOME%\lib\cdk-depict-2.8.jar;%APP_HOME%\lib\cdk-sdg-2.8.jar;%APP_HOME%\lib\cdk-builder3dtools-2.8.jar;%APP_HOME%\lib\cdk-smiles-2.8.jar;%APP_HOME%\lib\cdk-silent-2.8.jar;%APP_HOME%\lib\cdk-io-2.8.jar;%APP_HOME%\lib\cdk-forcefield-2.8.jar;%APP_HOME%\lib\cdk-smarts-2.8.jar;%APP_HOME%\lib\cdk-qsarbond-2.8.jar;%APP_HOME%\lib\cdk-charges-2.8.jar;%APP_HOME%\lib\cdk-ctab-2.8.jar;%APP_HOME%\lib\cdk-reaction-2.8.jar;%APP_HOME%\lib\cdk-isomorphism-2.8.jar;%APP_HOME%\lib\cdk-structgen-2.8.jar;%APP_HOME%\lib\cdk-formula-2.8.jar;%APP_HOME%\lib\cdk-valencycheck-2.8.jar;%APP_HOME%\lib\cdk-atomtype-2.8.jar;%APP_HOME%\lib\cdk-qsar-2.8.jar;%APP_HOME%\lib\cdk-signature-2.8.jar;%APP_HOME%\lib\cdk-cip-2.8.jar;%APP_HOME%\lib\cdk-renderawt-2.8.jar;%APP_HOME%\lib\cdk-renderextra-2.8.jar;%APP_HOME%\lib\cdk-renderbasic-2.8.jar;%APP_HOME%\lib\cdk-group-2.8.jar;%APP_HOME%\lib\cdk-standard-2.8.jar;%APP_HOME%\lib\cdk-hash-2.8.jar;%APP_HOME%\lib\cdk-render-2.8.jar;%APP_HOME%\lib\cdk-core-2.8.jar;%APP_HOME%\lib\cdk-dict-2.8.jar;%APP_HOME%\lib\cdk-diff-2.8.jar;%APP_HOME%\lib\cdk-interfaces-2.8.jar;%APP_HOME%\lib\json-1.0.jar;%APP_HOME%\lib\javax.json-1.0.4.jar;%APP_HOME%\lib\postgresql-42.2.1.jar;%APP_HOME%\lib\vecmath-1.5.2.jar;%APP_HOME%\lib\jama-1.0.3.jar;%APP_HOME%\lib\xom-1.3.7.jar;%APP_HOME%\lib\jna-inchi-core-1.1.jar;%APP_HOME%\lib\jna-inchi-api-1.1.jar;%APP_HOME%\lib\beam-func-1.3.4.jar;%APP_HOME%\lib\beam-core-1.3.4.jar;%APP_HOME%\lib\cdk-ioformats-2.8.jar;%APP_HOME%\lib\jgrapht-0.6.0.jar;%APP_HOME%\lib\base64-2.3.8.jar;%APP_HOME%\lib\GraphUtils-1.1.jar;%APP_HOME%\lib\jackson-annotations-2.14.2.jar;%APP_HOME%\lib\jackson-core-2.14.2.jar;%APP_HOME%\lib\jackson-databind-2.14.2.jar;%APP_HOME%\lib\commons-compress-1.21.jar;%APP_HOME%\lib\xz-1.9.jar;%APP_HOME%\lib\gson-2.8.9.jar;%APP_HOME%\lib\httpcore5-h2-5.1.3.jar;%APP_HOME%\lib\httpcore5-5.1.3.jar;%APP_HOME%\lib\commons-codec-1.15.jar;%APP_HOME%\lib\cdk-ionpot-2.8.jar;%APP_HOME%\lib\cdk-qsarionpot-2.8.jar;%APP_HOME%\lib\cdk-control-2.8.jar;%APP_HOME%\lib\cdk-qm-2.8.jar;%APP_HOME%\lib\cdk-jniinchi-support-2.8.jar;%APP_HOME%\lib\xercesImpl-2.8.0.jar;%APP_HOME%\lib\xalan-2.7.2.jar;%APP_HOME%\lib\jna-5.10.0.jar;%APP_HOME%\lib\jna-inchi-darwin-aarch64-1.1.jar;%APP_HOME%\lib\jna-inchi-darwin-x86-64-1.1.jar;%APP_HOME%\lib\jna-inchi-linux-arm-1.1.jar;%APP_HOME%\lib\jna-inchi-linux-x86-1.1.jar;%APP_HOME%\lib\jna-inchi-linux-x86-64-1.1.jar;%APP_HOME%\lib\jna-inchi-win32-x86-1.1.jar;%APP_HOME%\lib\jna-inchi-win32-x86-64-1.1.jar;%APP_HOME%\lib\signatures-1.1.jar;%APP_HOME%\lib\commons-math3-3.6.1.jar;%APP_HOME%\lib\commons-beanutils-1.9.4.jar;%APP_HOME%\lib\reflections8-0.11.7.jar;%APP_HOME%\lib\trove4j-3.0.3.jar;%APP_HOME%\lib\simple-xml-safe-2.7.1.jar;%APP_HOME%\lib\bcprov-jdk15on-1.69.jar;%APP_HOME%\lib\snappy-java-1.1.8.4.jar;%APP_HOME%\lib\checker-compat-qual-2.5.5.jar;%APP_HOME%\lib\google-http-client-1.39.2.jar;%APP_HOME%\lib\opencensus-contrib-http-util-0.28.0.jar;%APP_HOME%\lib\google-http-client-jackson2-1.39.2.jar;%APP_HOME%\lib\google-api-client-1.32.1.jar;%APP_HOME%\lib\google-oauth-client-1.31.5.jar;%APP_HOME%\lib\google-http-client-gson-1.39.2.jar;%APP_HOME%\lib\google-http-client-apache-v2-1.39.2.jar;%APP_HOME%\lib\google-api-services-storage-v1-rev20210127-1.32.1.jar;%APP_HOME%\lib\google-cloud-core-1.95.4.jar;%APP_HOME%\lib\auto-value-annotations-1.8.1.jar;%APP_HOME%\lib\proto-google-common-protos-2.3.2.jar;%APP_HOME%\lib\google-cloud-core-http-1.95.4.jar;%APP_HOME%\lib\google-http-client-appengine-1.39.2.jar;%APP_HOME%\lib\gax-httpjson-0.83.0.jar;%APP_HOME%\lib\gax-1.66.0.jar;%APP_HOME%\lib\google-auth-library-credentials-0.26.0.jar;%APP_HOME%\lib\google-auth-library-oauth2-http-0.26.0.jar;%APP_HOME%\lib\api-common-1.10.4.jar;%APP_HOME%\lib\javax.annotation-api-1.3.2.jar;%APP_HOME%\lib\opencensus-api-0.28.0.jar;%APP_HOME%\lib\grpc-context-1.39.0.jar;%APP_HOME%\lib\proto-google-iam-v1-1.0.14.jar;%APP_HOME%\lib\protobuf-java-3.17.3.jar;%APP_HOME%\lib\protobuf-java-util-3.17.3.jar;%APP_HOME%\lib\threetenbp-1.5.1.jar;%APP_HOME%\lib\jmzml-1.7.11.jar;%APP_HOME%\lib\fastutil-8.5.6.jar;%APP_HOME%\lib\cpdetector-1.0.10.jar;%APP_HOME%\lib\jaxb-runtime-2.3.3.jar;%APP_HOME%\lib\freehep-graphicsio-pdf-2.4.jar;%APP_HOME%\lib\freehep-graphicsio-ps-2.4.jar;%APP_HOME%\lib\serializer-2.7.2.jar;%APP_HOME%\lib\commons-logging-1.2.jar;%APP_HOME%\lib\commons-collections-3.2.2.jar;%APP_HOME%\lib\javassist-3.22.0-GA.jar;%APP_HOME%\lib\java-utilities-1.0-SNAPSHOT.jar;%APP_HOME%\lib\javatuples-1.3-SNAPSHOT.jar;%APP_HOME%\lib\chardet-1.0.jar;%APP_HOME%\lib\jakarta.xml.bind-api-2.3.3.jar;%APP_HOME%\lib\txw2-2.3.3.jar;%APP_HOME%\lib\istack-commons-runtime-3.0.11.jar;%APP_HOME%\lib\jakarta.activation-1.2.2.jar;%APP_HOME%\lib\joda-time-2.11.0.jar;%APP_HOME%\lib\log4j-1.2-api-2.18.0.jar;%APP_HOME%\lib\tagsoup-1.2.1.jar;%APP_HOME%\lib\freehep-graphicsio-tests-2.4.jar;%APP_HOME%\lib\freehep-graphicsio-2.4.jar;%APP_HOME%\lib\freehep-graphics2d-2.4.jar;%APP_HOME%\lib\freehep-graphicsbase-2.4.jar;%APP_HOME%\lib\kotlin-stdlib-common-1.6.20.jar;%APP_HOME%\lib\JavaPlot-1.0.jar;%APP_HOME%\lib\log4j-core-2.18.0.jar;%APP_HOME%\lib\commons-math-2.2.jar;%APP_HOME%\lib\log4j-api-2.18.0.jar;%APP_HOME%\lib\freehep-io-2.2.2.jar


@rem Execute fingerprinter_cli
"%JAVA_EXE%" %DEFAULT_JVM_OPTS% %JAVA_OPTS% %FINGERPRINTER_CLI_OPTS%  -classpath "%CLASSPATH%" de.unijena.bioinf.fingerid.SimpleFingerprinterCLI %*

:end
@rem End local scope for the variables with windows NT shell
if "%ERRORLEVEL%"=="0" goto mainEnd

:fail
rem Set variable FINGERPRINTER_CLI_EXIT_CONSOLE if you need the _script_ return code instead of
rem the _cmd.exe /c_ return code!
if  not "" == "%FINGERPRINTER_CLI_EXIT_CONSOLE%" exit 1
exit /b 1

:mainEnd
if "%OS%"=="Windows_NT" endlocal

:omega
