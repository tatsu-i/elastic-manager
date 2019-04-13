#!/bin/bash
INDEX=""
ES_HOST="localhost"
NUMBER=-1
function print_usage() {
cat << __EOF__
更新設定APIを使用して、一括インデックス作成のパフォーマンスが向上するように
インデックスを動的に変更してから、よりリアルタイムのインデックス作成状態に移行することができます。 
一括インデックス作成を開始する前に、次のコマンドを使用してください。

$ ./set_refresh_interval.sh -n -1

一括インデックス作成が完了したら、設定を更新します

$ ./set_refresh_interval.sh -n 1s

設定をデフォルト値にリセットするには、nullを使用します。

$ ./set_refresh_interval.sh -n null
__EOF__
    echo "Usage: $0 [-l host] [-i index] [-n number default -1]" 1>&2
    exit 1
}
while [ "$1" != "" ]; do
    case $1 in
        -l | -host )
            ES_HOST=$2
            if [ "$ES_HOST" = "" ]; then
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

curl -XPUT "http://${ES_HOST}:9200/${INDEX}/_settings" -d "
{
    \"index\" : {
        \"refresh_interval\" : \"${NUMBER}\"
    }
}"
