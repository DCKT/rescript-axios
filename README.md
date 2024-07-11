# rescript-axios

Axios bindings with [@dck/rescript-promise](https://github.com/DCKT/rescript-promise)

## Setup

```bash
yarn add rescript-axios @dck/rescript-promise
# or
npm i rescript-axios @dck/rescript-promise
```

Add to the `bsconfig.json` dependencies :

```json
{
  ...
  "bs-dependencies": ["rescript-axios"]
}
```

## Usage

### Basic

```rescript
Axios.get("http://myapi.com/test", ())
->Promise.Js.toResult
->Promise.mapOk(({data}) => data)
->Promise.tapError(err => {
  switch (err.response) {
    | Some({status: 404}) => Js.log("Not found")
    | e => Js.log2("an error occured", e)
  }
})
->ignore
```

### With config

```rescript
let config = Axios.makeConfig(~baseURL="http://localhost", ())

Axios.patch("/test", ~data=Js.Obj.empty(), ~config, ())
  ->Promise.Js.toResult
  ->Promise.tapOk(({data}) => {
    Js.log(data["resValue"])
  })
  ->ignore
```
