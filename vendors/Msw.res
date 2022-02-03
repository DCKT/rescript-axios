type handler
type server

module Rest = {
  type res

  module Ctx = {
    type t

    @send
    external json: (t, Js.t<'a>) => res = "json"

    @send
    external status: (t, int) => res = "status"
  }

  type callback<'req, 'res> = ('req, 'res, Ctx.t) => res

  @module("msw") @scope("rest")
  external get: (string, callback<'a, 'b>) => handler = "get"

  @module("msw") @scope("rest")
  external post: (string, callback<'a, 'b>) => handler = "post"

  @module("msw") @scope("rest")
  external patch: (string, callback<'a, 'b>) => handler = "patch"

  @module("msw") @scope("rest")
  external put: (string, callback<'a, 'b>) => handler = "put"

  @module("msw") @scope("rest")
  external delete: (string, callback<'a, 'b>) => handler = "delete"

  @module("msw") @scope("rest")
  external options: (string, callback<'a, 'b>) => handler = "options"
}

module Server = {
  type t

  @send
  external listen: t => unit = "listen"

  @send
  external resetHandlers: t => unit = "resetHandlers"

  @send
  external close: t => unit = "close"

  @module("msw/node") @variadic
  external setupServer: array<handler> => t = "setupServer"
}
