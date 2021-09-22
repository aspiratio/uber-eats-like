// APIリクエストに関する定数 複数のコンポーネントで参照するためこのファイルに書き出す

// APIリクエスト中に画面がいまどういう状態なのか？を知るための状態
export const REQUEST_STATE = {
  INITIAL: "INITIAL",
  LOADING: "LOADING",
  OK: "OK",
};

export const HTTP_STATUS_CODE = {
  NOT_ACCEPTABLE: 406,
};
