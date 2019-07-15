#!/usr/bin/env lein-exec

(use '[leiningen.exec :only (deps)])
(deps '[[clj-http "3.10.0"]])
(require '[clj-http.client :as client])
(require '[clojure.xml :as xml])           

(def sid "resolvetosavelives")
(def token "5b8ed10d2fe4745a7d9c9d09d7f156c47ea2eca8")

(def metadata-url "api.exotel.com/v1/Accounts/resolvetosavelives/Numbers/")

(defn phone-number-attributes-from-response [response]
  (let [parsed-metadata (group-by :tag (get-in response [:content 0 :content]))]
    {:phone-number  (get-in parsed-metadata [:PhoneNumber 0 :content 0])
     :dnd           (get-in parsed-metadata [:DND 0 :content 0])
     :type          (get-in parsed-metadata [:Type 0 :content 0])}))
 
(defn get-metadata [number]
  (-> number
   (#(client/get (str "https://" sid ":" token "@" metadata-url %)))
   (#(xml/parse (java.io.ByteArrayInputStream. (.getBytes (:body %)))))
   (#(phone-number-attributes-from-response %))))

(do 
  (let [numbers (rest *command-line-args*)]
    (println (get-metadata (first numbers)))))

