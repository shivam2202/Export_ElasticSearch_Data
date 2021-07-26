#!/bin/sh
#Elastic URL
elasticURL='eq-ip:eq-port/index/_search'

#Elastic Composite Aggregration Query
initialElasticQuery='{"size":0,"query":{"range":{"sendDate":{"from":"2021-01-01 00:00:00","to":null}}},"_source":false,"aggregations":{"groupby":{"composite":{"size":1000,"sources":[{"cdb4d0e9":{"terms":{"field":"term1","missing_bucket":true,"order":"asc"}}},{"87466b25":{"terms":{"field":"term2","missing_bucket":true,"order":"asc"}}},{"87466b20":{"terms":{"field":"term3","missing_bucket":true,"order":"asc"}}},{"c70b4e58":{"terms":{"field":"term4","missing_bucket":true,"order":"asc"}}},{"267df2d0":{"terms":{"field":"term5","missing_bucket":true,"order":"asc"}}},{"27d7e8f":{"terms":{"field":"term6","missing_bucket":true,"order":"asc"}}},{"d26a6518":{"terms":{"field":"term7","missing_bucket":true,"order":"asc"}}}]}}}}'

#Prepare csv from elasticsearch result.
prepare_csv_from_result() {
    echo $result | jq -r '.aggregations.groupby.buckets[] |.key as $object | .doc_count as $count | $object | .count=$count | map(.) | @csv'
}

# Invoke POST request and parse after key for next iteration
get_resultset() {
    result=$(curl -s --location --request POST "$elasticURL" --header 'Content-Type: application/json' --data-raw "$1")
    afterKey=$(echo $result | jq -r '.aggregations.groupby.after_key')
}

#First Call
get_resultset "$initialElasticQuery"

#echo $afterKey

#Repeat task until afterkey is null
while [ "$afterKey" != 'null' ]; do
    prepare_csv_from_result
    nextElasticQuery=$(echo $initialElasticQuery | jq --argjson afterKey "$afterKey" '.aggregations.groupby.composite.after=$afterKey')
    get_resultset "$nextElasticQuery"
    #echo $afterKey
done
