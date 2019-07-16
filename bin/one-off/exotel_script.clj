#!/usr/bin/env lein-exec

(use '[leiningen.exec :only (deps)])
(deps '[[clj-http "3.10.0"]])
(require '[clj-http.client :as client])
(require '[clojure.xml :as xml])

(def sid "resolvetosavelives")
(def token "5b8ed10d2fe4745a7d9c9d09d7f156c47ea2eca8")

(def metadata-url (str "https://" sid ":" token "@api.exotel.com/v1/Accounts/" sid "/Numbers/"))
(def whitelist-details-url (str "https://" sid ":" token "@api.exotel.com/v1/Accounts/" sid "/CustomerWhitelist/"))

(defn metadata-from-response [response]
  (let [parsed-metadata (group-by :tag (get-in response [:content 0 :content]))]
    {:phone-number  (get-in parsed-metadata [:PhoneNumber 0 :content 0])
     :dnd           (get-in parsed-metadata [:DND 0 :content 0])
     :phone-type          (get-in parsed-metadata [:Type 0 :content 0])}))

(defn whitelist-details-from-response [response]
  (let [parsed-metadata (group-by :tag (get-in response [:content 0 :content]))]
    {:status  (get-in parsed-metadata [:Status 0 :content 0])
     :expiry  (get-in parsed-metadata [:Expiry 0 :content 0])
     :user-type    (get-in parsed-metadata [:Type 0 :content 0])}))

(defn get-metadata [number]
  (-> number
      (#(client/get (str metadata-url %)))
      (#(xml/parse (java.io.ByteArrayInputStream. (.getBytes (:body %)))))
      (#(metadata-from-response %))))

(defn get-whitelist-details [number]
  (-> number
      (#(client/get (str whitelist-details-url %)))
      (#(xml/parse (java.io.ByteArrayInputStream. (.getBytes (:body %)))))
      (#(whitelist-details-from-response %))))


(do
  (let [number (first (rest *command-line-args*))
        whitelist-details (get-whitelist-details number)
        metadata (get-metadata number)]
    (println (merge metadata whitelist-details))))
