# ユーザーメモリー

## 言語設定
- 常に日本語で回答する

## Notion API Block取り扱い
- Notion MCPサーバーでNotionページに文章を追加する際の重要事項：

### Block Type選択
- 適切なBlock Typeを選択する（paragraph、heading、to_do、codeなど）
- 一部のBlock Type（templateなど）は非推奨のため使用を避ける
- APIで完全にサポートされていないBlock Typeがあることに注意

### Markdown変換時の注意点
- Markdown形式は要素ごとに分解して適切なBlock Typeに変換必須
- rich_text配列の構造に従って整形する
- plain_textプロパティでクリーンなテキスト抽出が可能
- カラーやアノテーション設定は標準化されたオプションを使用

### 制約事項
- Block幅やカラム設定は作成後に変更できない場合が多い
- 親子関係を持つネストしたBlockには特定のルールがある
- table_widthの設定ミスやchild block要件の不一致でエラーが発生しやすい
- ファイルアップロードタイプには制限がある

### 推奨事項
- 実装前に各Block Typeの仕様を確認する
- 参考: https://developers.notion.com/reference/block#block-type-objects