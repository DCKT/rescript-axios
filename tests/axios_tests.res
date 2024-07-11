open Test

let assertEqual = (~message, ~a, ~b) => assertion((a, b) => a === b, a, b, ~message)

let config = Axios.makeConfig(~baseURL="http://localhost", ())

let jsonResponse: Js.Json.t = {"test": 1}->Obj.magic

let setup = () => {
  let server = Msw.setupServer([
    Msw.Http.get("http://localhost/test", _ => {
      Msw.HttpResponse.json(jsonResponse)
    }),
    Msw.Http.get("http://localhost/testError", _ => {
      Msw.HttpResponse.jsonWithOptions(jsonResponse, {status: 500})
    }),
    Msw.Http.post("http://localhost/test", _ => {
      Msw.HttpResponse.json(jsonResponse)
    }),
    Msw.Http.post("http://localhost/testError", _ => {
      Msw.HttpResponse.jsonWithOptions(jsonResponse, {status: 500})
    }),
    Msw.Http.put("http://localhost/test", _ => {
      Msw.HttpResponse.json(jsonResponse)
    }),
    Msw.Http.put("http://localhost/testError", _ => {
      Msw.HttpResponse.jsonWithOptions(jsonResponse, {status: 500})
    }),
    Msw.Http.delete("http://localhost/test", _ => {
      Msw.HttpResponse.json(jsonResponse)
    }),
    Msw.Http.delete("http://localhost/testError", _ => {
      Msw.HttpResponse.jsonWithOptions(jsonResponse, {status: 500})
    }),
  ])
  server.listen()

  server
}

let teardown = (server: Msw.server) => {
  server.close()
}

let testAsyncWithServer = testAsyncWith(~setup, ~teardown, ...)

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
