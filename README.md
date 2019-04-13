# elastic-manager

ElasticSearchのメンテナンスツール詰め合わせ

- [elasticsearch-cli](https://www.npmjs.com/package/elasticsearch-cli)
- [escli](https://www.npmjs.com/package/escli)
- [elasticdump](https://www.npmjs.com/package/elasticdump)

## インデックスのバックアップとレストア
```
$ docker pull tatsui/elastic-manager:latest
$ docker run --rm -it tatsui/elastic-manager:latest bash
$ cd /scripts
# すべてのindexをバックアップ
$ ./backup-index.sh -l http://old-es:9200 |bash
# バックアップしたindexのレストア
$ ./restore-index.sh -l http://new-es:9200 |bash
```

