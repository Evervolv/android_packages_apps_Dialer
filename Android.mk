# Local modifications:
# * removed com.google.android.geo.API_KEY key. This should be added to
#      the manifest files in java/com/android/incallui/calllocation/impl/
#      and /java/com/android/incallui/maps/impl/
# * b/62417801 modify translation string naming convention:
#      $ find . -type d | grep 262 | rename 's/(values)\-([a-zA-Z\+\-]+)\-(mcc262-mnc01)/$1-$3-$2/'
# * b/37077388 temporarily disable proguard with javac
# * b/62875795 include manually generated GRPC service class:
#      $ protoc --plugin=protoc-gen-grpc-java=prebuilts/tools/common/m2/repository/io/grpc/protoc-gen-grpc-java/1.0.3/protoc-gen-grpc-java-1.0.3-linux-x86_64.exe \
#               --grpc-java_out=lite:"packages/apps/Dialer/java/com/android/voicemail/impl/" \
#               --proto_path="packages/apps/Dialer/java/com/android/voicemail/impl/transcribe/grpc/" "packages/apps/Dialer/java/com/android/voicemail/impl/transcribe/grpc/voicemail_transcription.proto"
LOCAL_PATH:= $(call my-dir)
include $(CLEAR_VARS)

# The base directory for Dialer sources.
BASE_DIR := java/com/android

# Exclude testing only class, not used anywhere here
EXCLUDE_FILES += \
	$(BASE_DIR)/contacts/common/format/testing/SpannedTestUtils.java

# Exclude rootcomponentgenerator
EXCLUDE_FILES += \
	$(call all-java-files-under, $(BASE_DIR)/dialer/rootcomponentgenerator) \

# All Dialer resources.
RES_DIRS := $(call all-subdir-named-dirs,res,.)

# Dialer manifest files to merge.
DIALER_MANIFEST_FILES := $(call all-named-files-under,AndroidManifest.xml,.)

# Merge all manifest files.
LOCAL_FULL_LIBS_MANIFEST_FILES := \
	$(addprefix $(LOCAL_PATH)/, $(DIALER_MANIFEST_FILES))

LOCAL_SRC_FILES := $(call all-java-files-under, $(BASE_DIR))
LOCAL_SRC_FILES += $(call all-proto-files-under, $(BASE_DIR))
LOCAL_SRC_FILES += $(call all-Iaidl-files-under, $(BASE_DIR))
LOCAL_SRC_FILES := $(filter-out $(EXCLUDE_FILES),$(LOCAL_SRC_FILES))

LOCAL_PROTOC_FLAGS := --proto_path=$(LOCAL_PATH)

LOCAL_RESOURCE_DIR := $(addprefix $(LOCAL_PATH)/, $(RES_DIRS))

# We specify each package explicitly to glob resource files.
include ${LOCAL_PATH}/packages.mk

LOCAL_AAPT_FLAGS := $(addprefix --extra-packages , $(LOCAL_AAPT_FLAGS))
LOCAL_AAPT_FLAGS += \
	--auto-add-overlay \
	--extra-packages me.leolin.shortcutbadger \

LOCAL_STATIC_JAVA_LIBRARIES := \
	android-common \
	android-support-dynamic-animation \
	com.android.vcard \
	dialer-commons-io-target \
	dialer-dagger2-target \
	dialer-disklrucache-target \
	dialer-gifdecoder-target \
	dialer-glide-target \
	dialer-j2objc-annotations-target \
	dialer-javax-annotation-api-target \
	dialer-javax-inject-target \
	dialer-libshortcutbadger-target \
	dialer-mime4j-core-target \
	dialer-mime4j-dom-target \
	dialer-guava-target \
	dialer-glide-target \
	dialer-glide-annotation-target \
	dialer-zxing-target \
	error_prone_annotations \
	jsr305 \
	libbackup \
	libphonenumber \
	volley \
	androidx.annotation_annotation \

LOCAL_STATIC_ANDROID_LIBRARIES := \
	android-support-core-ui \
	$(ANDROID_SUPPORT_DESIGN_TARGETS) \
	android-support-transition \
	android-support-v13 \
	android-support-v4 \
	android-support-v7-appcompat \
	android-support-v7-cardview \
	android-support-v7-recyclerview \

LOCAL_JAVA_LIBRARIES := \
	auto_value_annotations \
	org.apache.http.legacy \

LOCAL_ANNOTATION_PROCESSORS := \
	auto_value_plugin \
	javapoet-prebuilt-jar \
	dialer-dagger2 \
	dialer-dagger2-compiler \
	dialer-dagger2-producers \
	dialer-glide-annotation \
	dialer-glide-compiler \
	dialer-guava \
	dialer-javax-annotation-api \
	dialer-javax-inject \
	dialer-rootcomponentprocessor

LOCAL_ANNOTATION_PROCESSOR_CLASSES := \
  com.google.auto.value.processor.AutoValueProcessor,dagger.internal.codegen.ComponentProcessor,com.bumptech.glide.annotation.compiler.GlideAnnotationProcessor,com.android.dialer.rootcomponentgenerator.RootComponentProcessor

# Proguard includes
LOCAL_PROGUARD_FLAG_FILES := proguard.flags $(call all-named-files-under,proguard.*flags,$(BASE_DIR))
LOCAL_PROGUARD_ENABLED := custom

LOCAL_PROGUARD_ENABLED += optimization

LOCAL_SDK_VERSION := system_current
LOCAL_MODULE_TAGS := optional
LOCAL_PACKAGE_NAME := Dialer
LOCAL_CERTIFICATE := shared
LOCAL_PRIVILEGED_MODULE := true
LOCAL_PRODUCT_MODULE := true
LOCAL_USE_AAPT2 := true
LOCAL_REQUIRED_MODULES := privapp_whitelist_com.android.dialer
LOCAL_USES_LIBRARIES := org.apache.http.legacy

LOCAL_LICENSE_KINDS := SPDX-license-identifier-Apache-2.0
LOCAL_LICENSE_CONDITIONS := notice
LOCAL_NOTICE_FILE := $(LOCAL_PATH)/LICENSE
include $(BUILD_PACKAGE)

# Cleanup local state
BASE_DIR :=
EXCLUDE_FILES :=
RES_DIRS :=
DIALER_MANIFEST_FILES :=
EXCLUDE_MANIFESTS :=
EXCLUDE_EXTRA_PACKAGES :=

# Create references to prebuilt libraries.
include $(CLEAR_VARS)

LOCAL_PREBUILT_STATIC_JAVA_LIBRARIES := \
    dialer-dagger2-compiler:../../../prebuilts/tools/common/m2/repository/com/google/dagger/dagger-compiler/2.7/dagger-compiler-2.7.jar \
    dialer-dagger2:../../../prebuilts/tools/common/m2/repository/com/google/dagger/dagger/2.7/dagger-2.7.jar \
    dialer-dagger2-producers:../../../prebuilts/tools/common/m2/repository/com/google/dagger/dagger-producers/2.7/dagger-producers-2.7.jar \
    dialer-glide-annotation:../../../prebuilts/maven_repo/bumptech/com/github/bumptech/glide/annotation/SNAPSHOT/annotation-SNAPSHOT.jar \
    dialer-glide-compiler:../../../prebuilts/maven_repo/bumptech/com/github/bumptech/glide/compiler/SNAPSHOT/compiler-SNAPSHOT.jar \
    dialer-guava:../../../prebuilts/tools/common/m2/repository/com/google/guava/guava/23.0/guava-23.0.jar \
    dialer-javax-annotation-api:../../../prebuilts/tools/common/m2/repository/javax/annotation/javax.annotation-api/1.2/javax.annotation-api-1.2.jar \
    dialer-javax-inject:../../../prebuilts/tools/common/m2/repository/javax/inject/javax.inject/1/javax.inject-1.jar \

include $(BUILD_HOST_PREBUILT)

# Enumerate target prebuilts to avoid linker warnings like
# Dialer (java:sdk) should not link to dialer-guava (java:platform)
include $(CLEAR_VARS)

LOCAL_MODULE_CLASS := JAVA_LIBRARIES
LOCAL_MODULE := dialer-guava-target
LOCAL_LICENSE_KINDS := SPDX-license-identifier-Apache-2.0
LOCAL_LICENSE_CONDITIONS := notice
LOCAL_NOTICE_FILE := $(LOCAL_PATH)/LICENSE
LOCAL_SDK_VERSION := current
LOCAL_SRC_FILES := ../../../prebuilts/tools/common/m2/repository/com/google/guava/guava/23.0/guava-23.0.jar
LOCAL_UNINSTALLABLE_MODULE := true

include $(BUILD_PREBUILT)

include $(CLEAR_VARS)

LOCAL_MODULE_CLASS := JAVA_LIBRARIES
LOCAL_MODULE := dialer-dagger2-target
LOCAL_LICENSE_KINDS := SPDX-license-identifier-Apache-2.0
LOCAL_LICENSE_CONDITIONS := notice
LOCAL_NOTICE_FILE := $(LOCAL_PATH)/LICENSE
LOCAL_SDK_VERSION := current
LOCAL_SRC_FILES := ../../../prebuilts/tools/common/m2/repository/com/google/dagger/dagger/2.7/dagger-2.7.jar
LOCAL_UNINSTALLABLE_MODULE := true

include $(BUILD_PREBUILT)

include $(CLEAR_VARS)

LOCAL_MODULE_CLASS := JAVA_LIBRARIES
LOCAL_MODULE := dialer-disklrucache-target
LOCAL_LICENSE_KINDS := SPDX-license-identifier-Apache-2.0
LOCAL_LICENSE_CONDITIONS := notice
LOCAL_NOTICE_FILE := $(LOCAL_PATH)/LICENSE
LOCAL_SDK_VERSION := current
LOCAL_SRC_FILES := ../../../prebuilts/maven_repo/bumptech/com/github/bumptech/glide/disklrucache/SNAPSHOT/disklrucache-SNAPSHOT.jar
LOCAL_UNINSTALLABLE_MODULE := true

include $(BUILD_PREBUILT)

include $(CLEAR_VARS)

LOCAL_MODULE_CLASS := JAVA_LIBRARIES
LOCAL_MODULE := dialer-gifdecoder-target
LOCAL_LICENSE_KINDS := SPDX-license-identifier-Apache-2.0
LOCAL_LICENSE_CONDITIONS := notice
LOCAL_NOTICE_FILE := $(LOCAL_PATH)/LICENSE
LOCAL_SDK_VERSION := current
LOCAL_SRC_FILES := ../../../prebuilts/maven_repo/bumptech/com/github/bumptech/glide/gifdecoder/SNAPSHOT/gifdecoder-SNAPSHOT.jar
LOCAL_UNINSTALLABLE_MODULE := true

include $(BUILD_PREBUILT)

include $(CLEAR_VARS)

LOCAL_MODULE_CLASS := JAVA_LIBRARIES
LOCAL_MODULE := dialer-glide-target
LOCAL_LICENSE_KINDS := SPDX-license-identifier-Apache-2.0
LOCAL_LICENSE_CONDITIONS := notice
LOCAL_NOTICE_FILE := $(LOCAL_PATH)/LICENSE
LOCAL_SDK_VERSION := current
LOCAL_SRC_FILES := ../../../prebuilts/maven_repo/bumptech/com/github/bumptech/glide/glide/SNAPSHOT/glide-SNAPSHOT.jar
LOCAL_UNINSTALLABLE_MODULE := true

include $(BUILD_PREBUILT)

include $(CLEAR_VARS)

LOCAL_MODULE_CLASS := JAVA_LIBRARIES
LOCAL_MODULE := dialer-glide-annotation-target
LOCAL_LICENSE_KINDS := SPDX-license-identifier-Apache-2.0
LOCAL_LICENSE_CONDITIONS := notice
LOCAL_NOTICE_FILE := $(LOCAL_PATH)/LICENSE
LOCAL_SDK_VERSION := current
LOCAL_SRC_FILES := ../../../prebuilts/maven_repo/bumptech/com/github/bumptech/glide/annotation/SNAPSHOT/annotation-SNAPSHOT.jar
LOCAL_UNINSTALLABLE_MODULE := true

include $(BUILD_PREBUILT)

include $(CLEAR_VARS)

LOCAL_MODULE_CLASS := JAVA_LIBRARIES
LOCAL_MODULE := dialer-javax-annotation-api-target
LOCAL_LICENSE_KINDS := SPDX-license-identifier-Apache-2.0
LOCAL_LICENSE_CONDITIONS := notice
LOCAL_NOTICE_FILE := $(LOCAL_PATH)/LICENSE
LOCAL_SDK_VERSION := current
LOCAL_SRC_FILES := ../../../prebuilts/tools/common/m2/repository/javax/annotation/javax.annotation-api/1.2/javax.annotation-api-1.2.jar
LOCAL_UNINSTALLABLE_MODULE := true

include $(BUILD_PREBUILT)

include $(CLEAR_VARS)

LOCAL_MODULE_CLASS := JAVA_LIBRARIES
LOCAL_MODULE := dialer-libshortcutbadger-target
LOCAL_LICENSE_KINDS := SPDX-license-identifier-Apache-2.0
LOCAL_LICENSE_CONDITIONS := notice
LOCAL_NOTICE_FILE := $(LOCAL_PATH)/LICENSE
LOCAL_SDK_VERSION := current
LOCAL_SRC_FILES := ../../../prebuilts/tools/common/m2/repository/me/leolin/ShortcutBadger/1.1.13/ShortcutBadger-1.1.13.jar
LOCAL_UNINSTALLABLE_MODULE := true

include $(BUILD_PREBUILT)

include $(CLEAR_VARS)

LOCAL_MODULE_CLASS := JAVA_LIBRARIES
LOCAL_MODULE := dialer-javax-inject-target
LOCAL_LICENSE_KINDS := SPDX-license-identifier-Apache-2.0
LOCAL_LICENSE_CONDITIONS := notice
LOCAL_NOTICE_FILE := $(LOCAL_PATH)/LICENSE
LOCAL_SDK_VERSION := current
LOCAL_SRC_FILES := ../../../prebuilts/tools/common/m2/repository/javax/inject/javax.inject/1/javax.inject-1.jar
LOCAL_UNINSTALLABLE_MODULE := true

include $(BUILD_PREBUILT)

include $(CLEAR_VARS)

LOCAL_MODULE_CLASS := JAVA_LIBRARIES
LOCAL_MODULE := dialer-commons-io-target
LOCAL_LICENSE_KINDS := SPDX-license-identifier-Apache-2.0
LOCAL_LICENSE_CONDITIONS := notice
LOCAL_NOTICE_FILE := $(LOCAL_PATH)/LICENSE
LOCAL_SDK_VERSION := current
LOCAL_SRC_FILES := ../../../prebuilts/tools/common/m2/repository/commons-io/commons-io/2.4/commons-io-2.4.jar
LOCAL_UNINSTALLABLE_MODULE := true

include $(BUILD_PREBUILT)

include $(CLEAR_VARS)

LOCAL_MODULE_CLASS := JAVA_LIBRARIES
LOCAL_MODULE := dialer-mime4j-core-target
LOCAL_LICENSE_KINDS := SPDX-license-identifier-Apache-2.0
LOCAL_LICENSE_CONDITIONS := notice
LOCAL_NOTICE_FILE := $(LOCAL_PATH)/LICENSE
LOCAL_SDK_VERSION := current
LOCAL_SRC_FILES := ../../../prebuilts/tools/common/m2/repository/org/apache/james/apache-mime4j-core/0.7.2/apache-mime4j-core-0.7.2.jar
LOCAL_UNINSTALLABLE_MODULE := true

include $(BUILD_PREBUILT)

include $(CLEAR_VARS)

LOCAL_MODULE_CLASS := JAVA_LIBRARIES
LOCAL_MODULE := dialer-mime4j-dom-target
LOCAL_LICENSE_KINDS := SPDX-license-identifier-Apache-2.0
LOCAL_LICENSE_CONDITIONS := notice
LOCAL_NOTICE_FILE := $(LOCAL_PATH)/LICENSE
LOCAL_SDK_VERSION := current
LOCAL_SRC_FILES := ../../../prebuilts/tools/common/m2/repository/org/apache/james/apache-mime4j-dom/0.7.2/apache-mime4j-dom-0.7.2.jar
LOCAL_UNINSTALLABLE_MODULE := true

include $(BUILD_PREBUILT)

include $(CLEAR_VARS)

LOCAL_MODULE_CLASS := JAVA_LIBRARIES
LOCAL_MODULE := dialer-zxing-target
LOCAL_LICENSE_KINDS := SPDX-license-identifier-Apache-2.0
LOCAL_LICENSE_CONDITIONS := notice
LOCAL_NOTICE_FILE := $(LOCAL_PATH)/LICENSE
LOCAL_SDK_VERSION := current
LOCAL_SRC_FILES := ../../../external/zxing/core/core.jar
LOCAL_UNINSTALLABLE_MODULE := true

include $(BUILD_PREBUILT)

include $(CLEAR_VARS)

LOCAL_MODULE_CLASS := JAVA_LIBRARIES
LOCAL_MODULE := dialer-j2objc-annotations-target
LOCAL_LICENSE_KINDS := SPDX-license-identifier-Apache-2.0
LOCAL_LICENSE_CONDITIONS := notice
LOCAL_NOTICE_FILE := $(LOCAL_PATH)/LICENSE
LOCAL_SDK_VERSION := current
LOCAL_SRC_FILES := ../../../prebuilts/tools/common/m2/repository/com/google/j2objc/j2objc-annotations/1.1/j2objc-annotations-1.1.jar
LOCAL_UNINSTALLABLE_MODULE := true

include $(BUILD_PREBUILT)

include $(CLEAR_VARS)

LOCAL_MODULE := dialer-rootcomponentprocessor
LOCAL_LICENSE_KINDS := SPDX-license-identifier-Apache-2.0
LOCAL_LICENSE_CONDITIONS := notice
LOCAL_NOTICE_FILE := $(LOCAL_PATH)/LICENSE
LOCAL_MODULE_CLASS := JAVA_LIBRARIES
LOCAL_IS_HOST_MODULE := true
BASE_DIR := java/com/android

LOCAL_SRC_FILES := \
	$(call all-java-files-under, $(BASE_DIR)/dialer/rootcomponentgenerator) \
        $(BASE_DIR)/dialer/inject/DialerRootComponent.java \
        $(BASE_DIR)/dialer/inject/DialerVariant.java \
        $(BASE_DIR)/dialer/inject/HasRootComponent.java \
        $(BASE_DIR)/dialer/inject/IncludeInDialerRoot.java \
        $(BASE_DIR)/dialer/inject/RootComponentGeneratorMetadata.java

LOCAL_STATIC_JAVA_LIBRARIES := \
	dialer-guava \
	dialer-dagger2 \
	javapoet-prebuilt-jar \
	auto_service_annotations \
	auto_common \
	dialer-javax-annotation-api \
	dialer-javax-inject \
	error_prone_annotations

LOCAL_JAVA_LANGUAGE_VERSION := 1.8

include $(BUILD_HOST_JAVA_LIBRARY)

include $(CLEAR_VARS)
