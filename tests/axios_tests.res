open Test

let assertEqual = (~message, ~a, ~b) => assertion((a, b) => a === b, a, b, ~message)

let config = Axios.makeConfig(~baseURL="http://localhost", ())

let setup = () => {
  let server = Msw.Server.setupServer([
    Msw.Rest.get("http://localhost/test", (_, res, ctx) => {
      res(ctx->Msw.Rest.Ctx.json({"test": 1}))
    }),
    Msw.Rest.get("http://localhost/testError", (_, res, ctx) => {
      res(. ctx->Msw.Rest.Ctx.status(500), ctx->Msw.Rest.Ctx.json({"test": 1}))
    }),
    Msw.Rest.post("http://localhost/test", (_, res, ctx) => {
      res(ctx->Msw.Rest.Ctx.json({"test": 1}))
    }),
    Msw.Rest.post("http://localhost/testError", (_, res, ctx) => {
      res(. ctx->Msw.Rest.Ctx.status(500), ctx->Msw.Rest.Ctx.json({"test": 1}))
    }),
    Msw.Rest.put("http://localhost/test", (_, res, ctx) => {
      res(ctx->Msw.Rest.Ctx.json({"test": 1}))
    }),
    Msw.Rest.put("http://localhost/testError", (_, res, ctx) => {
      res(. ctx->Msw.Rest.Ctx.status(500), ctx->Msw.Rest.Ctx.json({"test": 1}))
    }),
    Msw.Rest.patch("http://localhost/test", (_, res, ctx) => {
      res(ctx->Msw.Rest.Ctx.json({"test": 1}))
    }),
    Msw.Rest.patch("http://localhost/testError", (_, res, ctx) => {
      res(. ctx->Msw.Rest.Ctx.status(500), ctx->Msw.Rest.Ctx.json({"test": 1}))
    }),
    Msw.Rest.delete("http://localhost/test", (_, res, ctx) => {
      res(ctx->Msw.Rest.Ctx.json({"test": 1}))
    }),
    Msw.Rest.delete("http://localhost/testError", (_, res, ctx) => {
      res(. ctx->Msw.Rest.Ctx.status(500), ctx->Msw.Rest.Ctx.json({"test": 1}))
    }),
    Msw.Rest.options("http://localhost/test", (_, res, ctx) => {
      res(ctx->Msw.Rest.Ctx.json({"test": 1}))
    }),
    Msw.Rest.options("http://localhost/testError", (_, res, ctx) => {
      res(. ctx->Msw.Rest.Ctx.status(500), ctx->Msw.Rest.Ctx.json({"test": 1}))
    }),
  ])
  server->Msw.Server.listen

  server
}

let teardown = server => {
  server->Msw.Server.close
}

let testAsyncWithServer = testAsyncWith(~setup, ~teardown)

testAsyncWithServer("GET - simple", (_, done) => {
  Axios.get("/test", ~config, ())
  ->Promise.Js.toResult
  ->Promise.tap(_ => {
    done()
  })
  ->ignore
})

testAsyncWithServer("GET - result + data", (_, done) => {
  Axios.get("/test", ~config, ())
  ->Promise.Js.toResult
  ->Promise.tapOk(({data}) => {
    assertEqual(~a=data["test"], ~b=1, ~message="Should receive data")
    done()
  })
  ->ignore
})

testAsyncWithServer("GET - result + error", (_, done) => {
  Axios.get("/testError", ~config, ())
  ->Promise.Js.toResult
  ->Promise.tapOk(_ => {
    fail(~message="Should'nt be ok", ())
  })
  ->Promise.tapError(error => {
    switch error.response {
    | Some({status}) => assertEqual(~a=status, ~b=500, ~message="Should match status error code")
    | _ => fail(~message="The error should contain a response with a status code", ())
    }

    done()
  })
  ->ignore
})

testAsyncWithServer("POST - result + data", (_, done) => {
  Axios.post("/test", ~data=Js.Obj.empty(), ~config, ())
  ->Promise.Js.toResult
  ->Promise.tapOk(({data}) => {
    assertEqual(~a=data["test"], ~b=1, ~message="Should receive data")
    done()
  })
  ->ignore
})

testAsyncWithServer("POST - result + error", (_, done) => {
  Axios.post("/testError", ~data=Js.Obj.empty(), ~config, ())
  ->Promise.Js.toResult
  ->Promise.tapOk(_ => {
    fail(~message="Should'nt be ok", ())
  })
  ->Promise.tapError(error => {
    switch error.response {
    | Some({status}) => assertEqual(~a=status, ~b=500, ~message="Should match status error code")
    | _ => fail(~message="The error should contain a response with a status code", ())
    }

    done()
  })
  ->ignore
})

testAsyncWithServer("PUT - result + data", (_, done) => {
  Axios.put("/test", ~data=Js.Obj.empty(), ~config, ())
  ->Promise.Js.toResult
  ->Promise.tapOk(({data}) => {
    assertEqual(~a=data["test"], ~b=1, ~message="Should receive data")
    done()
  })
  ->ignore
})

testAsyncWithServer("PUT - result + error", (_, done) => {
  Axios.put("/testError", ~data=Js.Obj.empty(), ~config, ())
  ->Promise.Js.toResult
  ->Promise.tapOk(_ => {
    fail(~message="Should'nt be ok", ())
  })
  ->Promise.tapError(error => {
    switch error.response {
    | Some({status}) => assertEqual(~a=status, ~b=500, ~message="Should match status error code")
    | _ => fail(~message="The error should contain a response with a status code", ())
    }

    done()
  })
  ->ignore
})

testAsyncWithServer("PATCH - result + data", (_, done) => {
  Axios.patch("/test", ~data=Js.Obj.empty(), ~config, ())
  ->Promise.Js.toResult
  ->Promise.tapOk(({data}) => {
    assertEqual(~a=data["test"], ~b=1, ~message="Should receive data")
    done()
  })
  ->ignore
})

testAsyncWithServer("PATCH - result + error", (_, done) => {
  Axios.patch("/testError", ~data=Js.Obj.empty(), ~config, ())
  ->Promise.Js.toResult
  ->Promise.tapOk(_ => {
    fail(~message="Should'nt be ok", ())
  })
  ->Promise.tapError(error => {
    switch error.response {
    | Some({status}) => assertEqual(~a=status, ~b=500, ~message="Should match status error code")
    | _ => fail(~message="The error should contain a response with a status code", ())
    }

    done()
  })
  ->ignore
})

testAsyncWithServer("DELETE - result + data", (_, done) => {
  Axios.delete("/test", ~config, ())
  ->Promise.Js.toResult
  ->Promise.tapOk(({data}) => {
    assertEqual(~a=data["test"], ~b=1, ~message="Should receive data")
    done()
  })
  ->ignore
})

testAsyncWithServer("DELETE - result + error", (_, done) => {
  Axios.delete("/testError", ~config, ())
  ->Promise.Js.toResult
  ->Promise.tapOk(_ => {
    fail(~message="Should'nt be ok", ())
  })
  ->Promise.tapError(error => {
    switch error.response {
    | Some({status}) => assertEqual(~a=status, ~b=500, ~message="Should match status error code")
    | _ => fail(~message="The error should contain a response with a status code", ())
    }

    done()
  })
  ->ignore
})
testAsyncWithServer("OPTIONS - result + data", (_, done) => {
  Axios.options("/test", ~config, ())
  ->Promise.Js.toResult
  ->Promise.tapOk(({data}) => {
    assertEqual(~a=data["test"], ~b=1, ~message="Should receive data")
    done()
  })
  ->ignore
})

testAsyncWithServer("OPTIONS - result + error", (_, done) => {
  Axios.options("/testError", ~config, ())
  ->Promise.Js.toResult
  ->Promise.tapOk(_ => {
    fail(~message="Should'nt be ok", ())
  })
  ->Promise.tapError(error => {
    switch error.response {
    | Some({status}) => assertEqual(~a=status, ~b=500, ~message="Should match status error code")
    | _ => fail(~message="The error should contain a response with a status code", ())
    }

    done()
  })
  ->ignore
})
