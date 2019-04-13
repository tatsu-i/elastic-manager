#!/bin/bash
INDEX=""
ES_URL="http://elasticsearch:9200"
NUMBER=1
function print_usage() {
	cat << __EOF___
既存のindexのshard数は変更できません。

__EOF___
    echo "Usage: $0 [-l host] [-i index] [-n number default 1]" 1>&2
    exit 1
}
while [ "$1" != "" ]; do
    case $1 in
        -l | -host )
            ES_URL=$2
            if [ "$ES_URL" = "" ]; then
                echo "Error: Missing Elasticsearch URL"
                print_usage
                exit 1
            fi
            ;;

        -i | -index )
            INDEX=$2
            if [ "$INDEX" = "" ]; then
                echo "Error: Missing index pattern"
                print_usage
                exit 1
            fi
            ;;

        -n | -number )
            NUMBER=$2
            ;;

        -h | -help )
            print_usage
            exit 0
            ;;

         *)
            echo "Error: Unknown option $2"
            print_usage
            exit 1
            ;;
    esac
    shift 2
done

curl -XPUT "${ES_URL}/_template/${INDEX}" -d "
{
    \"template\" : \"${INDEX}*\",
    \"settings\" : {
        \"number_of_shards\" : ${NUMBER}
    }
}" -H "Content-Type: application/json"
