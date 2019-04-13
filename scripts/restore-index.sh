#!/bin/bash
INDEX=""
ES_URL="http://elasticsearch:9200"
function print_usage() {
    echo "Usage: $0 [-l host] [-d dir]" 1>&2
    exit 1
}
DRY_RUN=0

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

        -d | -dir )
            BACKUP_DIR=$2
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

for dumpfile in $(ls ${BACKUP_DIR}/*)
do
	index=$(basename -s .json.gz ${dumpfile})
	echo "gzip -dc ${dumpfile} | elasticdump --limit 10000 --input=$ --output=\"${ES_URL}/${index}\""
done
