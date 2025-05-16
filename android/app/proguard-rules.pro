# Keep slf4j classes
-keep class org.slf4j.** { *; }
-keep class org.slf4j.impl.** { *; }
-keep class org.slf4j.helpers.** { *; }
-keep class org.slf4j.spi.** { *; }
 
# Keep slf4j bindings
-keep class org.slf4j.impl.StaticLoggerBinder { *; }
-keep class org.slf4j.impl.StaticMDCBinder { *; }
-keep class org.slf4j.impl.StaticMarkerBinder { *; } 