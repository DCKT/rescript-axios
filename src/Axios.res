type config

module Headers = {
  type t

  external fromObj: Js.t<{..}> => t = "%identity"
  external fromDict: Js.Dict.t<string> => t = "%identity"
}

module CancelToken = {
  type t

  @module("axios")
  external source: unit => t = "source"
}

type requestTransformer<'data, 'a, 'transformedData> = ('data, Js.t<'a>) => 'transformedData
type responseTransformer<'data, 'transformedData> = 'data => 'transformedData
type paramsSerializer<'params, 'serializedParams> = 'params => 'serializedParams
type auth = {
  username: string,
  password: string,
}
type proxy = {host: int, port: int, auth: auth}

type response<'data> = {
  data: 'data,
  status: int,
  statusText: string,
  headers: Js.Dict.t<string>,
  config: config,
}

type error<'responseData, 'request> = {
  request: option<'request>,
  response: option<response<'responseData>>,
  message: string,
}

type adapter<'a, 'b, 'err> = config => Promise.Js.t<response<'a>, 'err>

@module("axios")
external isAxiosError: error<'a, 'c> => bool = "isAxiosError"

@obj
external makeConfig: (
  ~url: string=?,
  ~_method: string=?,
  ~baseURL: string=?,
  ~transformRequest: array<requestTransformer<'data, Js.t<'a>, 'tranformedData>>=?,
  ~transformResponse: array<responseTransformer<'data, 'tranformedData>>=?,
  ~headers: Headers.t=?,
  ~params: Js.t<'params>=?,
  ~paramsSerializer: paramsSerializer<'params, 'serializedParams>=?,
  ~data: Js.t<'data>=?,
  ~timeout: int=?,
  ~withCredentials: bool=?,
  ~adapter: adapter<'a, 'b, 'err>=?,
  ~auth: auth=?,
  ~responseType: string=?,
  ~xsrfCookieName: string=?,
  ~xsrfHeaderName: string=?,
  ~onUploadProgress: 'uploadProgress => unit=?,
  ~onDownloadProgress: 'downloadProgress => unit=?,
  ~maxContentLength: int=?,
  ~validateStatus: int => bool=?,
  ~maxRedirects: int=?,
  ~socketPath: string=?,
  ~proxy: proxy=?,
  ~cancelToken: CancelToken.t=?,
  unit,
) => config = ""

@module("axios")
external get: (
  string,
  ~config: config=?,
  unit,
) => Promise.Js.t<response<'data>, error<'responseData, 'request>> = "get"

@module("axios")
external post: (
  string,
  ~data: 'a,
  ~config: config=?,
  unit,
) => Promise.Js.t<response<'data>, error<'responseData, 'request>> = "post"

@module("axios")
external put: (
  string,
  ~data: 'a,
  ~config: config=?,
  unit,
) => Promise.Js.t<response<'data>, error<'responseData, 'request>> = "put"

@module("axios")
external patch: (
  string,
  ~data: 'a,
  ~config: config=?,
  unit,
) => Promise.Js.t<response<'data>, error<'responseData, 'request>> = "patch"

@module("axios")
external delete: (
  string,
  ~config: config=?,
  unit,
) => Promise.Js.t<response<'data>, error<'responseData, 'request>> = "delete"

@module("axios")
external options: (
  string,
  ~config: config=?,
  unit,
) => Promise.Js.t<response<'data>, error<'responseData, 'request>> = "options"

module Interceptors = {
  @module("axios") @scope(("default", "interceptors", "request"))
  external requestInterceptor: ('config => Promise.Js.t<'updatedConfig, 'error>) => unit = "use"

  @module("axios") @scope(("default", "interceptors", "response"))
  external responseInterceptor: ('response => Promise.Js.t<'updatedResponse, 'error>) => unit =
    "use"
}
