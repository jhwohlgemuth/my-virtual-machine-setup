{:user {
        :aliases {
                  "lint" ["do" ["cljfmt" "check"] "kibit"]
                  "fix" ["do" ["cljfmt" "fix"] ["kibit" "--replace" "--interactive"]]}
        :plugins [
                  [lein-drip "0.1.1-SNAPSHOT"];; faster JVM
                  ;; Ultra is awesome, but v0.6.0 has issues with JDK v11
                ;   [venantius/ultra "0.6.0"];; pretty print and stuff
                  [lein-auto "0.1.3"];; watch tasks
                  [lein-try "0.4.3"];; REPL experimenting
                  ;; Project Scaffolding
                  [chestnut/lein-template "0.15.2"]
                  ;; Dependency Management
                  [com.livingsocial/lein-dependency-check "0.2.2"]
                  [lein-ancient "0.6.10"]
                  [lein-nvd "0.3.1"];; National Vulnerability Database dependency-checker
                  ;; Code Quality
                  [lein-cljfmt "0.5.7"]
                  [lein-kibit "0.1.5"]
                  [lein-bikeshed "0.4.1"]
                  ;; Testing
                  [lein-cloverage "1.0.9"]]}}
