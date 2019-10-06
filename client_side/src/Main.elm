module Main exposing (main)

import Benchmark exposing (..)
import Benchmark.Runner exposing (BenchmarkProgram, program)
import Bytes
import Bytes.Encode as BE
import Bytes.Decode as BD
import Dict exposing (Dict)
import Eetf.Encode as EE
import Eetf.Decode as ED
import Json.Encode as JE
import Json.Decode as JD
import Person
import Random

main : BenchmarkProgram
main = program suite

suite : Benchmark
suite = describe "Suite" [ encode, decode ]

encode : Benchmark
encode =
  let
      listInt_ = listInt
  in
  describe "Encode"
    [ describe "int"
        [ Benchmark.compare "max int"
            "JSON"
            (\_ -> JE.encode 0 (JE.int largeInt))
            "EETF"
            (\_ -> EE.encode (EE.int largeInt))
        ]
    , describe "list"
        [ Benchmark.compare "ints"
            "JSON"
            (\_ -> JE.encode 0 (JE.list JE.int listInt_))
            "EETF"
            (\_ -> EE.encode (EE.list EE.int listInt_))
        ]
    , describe "dict"
        [ Benchmark.compare "string => int"
            "JSON"
            (\_ -> JE.encode 0 (JE.dict identity JE.int stringIntDict))
            "EETF"
            (\_ -> EE.encode (EE.dict identity EE.int stringIntDict))
        ]
    , describe "person"
        [ Benchmark.compare "person"
            "JSON"
            (\_ -> JE.encode 0 (Person.jsonEncoder Person.person))
            "EETF"
            (\_ -> EE.encode (Person.eetfEncoder Person.person))
        ]
    ]

decode : Benchmark
decode =
  let
      jsonLargeInt = JE.encode 0 (JE.int largeInt)
      eetfLargeInt = EE.encode (EE.int largeInt)

      jsonListInt = JE.encode 0 (JE.list JE.int listInt)
      eetfListInt = EE.encode (EE.list EE.int listInt)
      listIntJsonDecoder = JD.list JD.int
      listIntEetfDecoder = ED.list ED.int

      jsonStringIntDict = JE.encode 0 (JE.dict identity JE.int stringIntDict)
      eetfStringIntDict = EE.encode (EE.dict identity EE.int stringIntDict)
      stringIntDictJsonDecoder = JD.dict JD.int
      stringIntDictEetfDecoder = ED.dict (ED.tuple2 ED.string ED.int)

      jsonPerson = JE.encode 0 (Person.jsonEncoder Person.person)
      eetfPerson = EE.encode (Person.eetfEncoder Person.person)
  in
  describe "Decode"
    [ describe "int"
        [ Benchmark.compare "max int"
            "JSON"
            (\_ -> JD.decodeString JD.int jsonLargeInt)
            "EETF"
            (\_ -> ED.decodeBytes ED.int eetfLargeInt)
        ]
    , describe "list"
        [ Benchmark.compare "ints"
            "JSON"
            (\_ -> JD.decodeString listIntJsonDecoder jsonListInt)
            "EETF"
            (\_ -> ED.decodeBytes listIntEetfDecoder eetfListInt)
        ]
    , describe "dict"
        [ Benchmark.compare "string => int"
            "JSON"
            (\_ -> JD.decodeString stringIntDictJsonDecoder jsonStringIntDict)
            "EETF"
            (\_ -> ED.decodeBytes stringIntDictEetfDecoder eetfStringIntDict)
        ]
    , describe "person"
        [ Benchmark.compare "person"
            "JSON"
            (\_ -> JD.decodeString Person.jsonDecoder jsonPerson)
            "EETF"
            (\_ -> ED.decodeBytes Person.eetfDecoder eetfPerson)
        ]
    ]

-- Helpers

largeInt : Int
largeInt = Random.maxInt

listInt : List Int
listInt = List.range 0 100

stringIntDict : Dict String Int
stringIntDict =
  Dict.fromList
    [ ("Tom", 42)
    , ("Sue", 38)
    , ("Steve", 52)
    , ("Jordan", 19)
    , ("Gabriel", 98)
    , ("Sally", 65)
    , ("Donald", 101)
    , ("Gustave", 44)
    , ("Harry", 17)
    , ("Alisson", 33)
    ]
