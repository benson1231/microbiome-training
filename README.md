# microbiome-training

可以使用官方工具[qiime2 view](https://view.qiime2.org/)查看 `qzv` 檔

## 環境
```bash
docker compose run --rm qiime2 bash
```

## export `qzv` `qza` file

```bash
qiime tools export \
  --input-path FILE-PATH \
  --output-path OUTPUT-PATH
```