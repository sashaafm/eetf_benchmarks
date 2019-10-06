module Person exposing
  ( Person
  , person
  , jsonEncoder
  , jsonDecoder
  , eetfEncoder
  , eetfDecoder
  )

import Dict exposing (Dict)
import Eetf.Encode as EE
import Eetf.Decode as ED
import Json.Encode as JE
import Json.Decode as JD

type Role = User | Member | Admin
type alias House = { location : String, area : Int }
type Industry = Pharma | Tech | Sports | Retail
type alias Company = { name : String, employeeCount : Int, industry : Industry }
type alias Person =
  { name : String
  , role : Role
  , nicknames : List String
  , houses : List House
  , crimes : List (String, Int)
  , father : String
  , mother : String
  , company : Company
  }

person : Person
person =
  Person
    "Tomás"
    Member
    [ "El Matador", "Big Shot", "OG T" ]
    [ (House "Lisbon" 80), (House "Stockholm" 120) ]
    [ ("murder", 0), ("grand theft", 2) ]
    "Júlio"
    "Clotilde"
    (Company "TopCode" 20 Tech)

jsonDecoder : JD.Decoder Person
jsonDecoder =
  JD.map8 Person
    (JD.field "name" JD.string)
    (JD.field "role" jsonRoleDecoder)
    (JD.field "nicknames" (JD.list JD.string))
    (JD.field "houses" (JD.list jsonHouseDecoder))
    (JD.field "crimes" (JD.keyValuePairs JD.int))
    (JD.field "father" JD.string)
    (JD.field "mother" JD.string)
    (JD.field "company" jsonCompanyDecoder)

eetfDecoder : ED.Decoder Person
eetfDecoder =
  ED.map8 Person
    (ED.field "name" ED.string)
    (ED.field "role" eetfRoleDecoder)
    (ED.field "nicknames" (ED.list ED.string))
    (ED.field "houses" (ED.list eetfHouseDecoder))
    (ED.field "crimes" (ED.keyValuePairs (ED.tuple2 ED.string ED.int)))
    (ED.field "father" ED.string)
    (ED.field "mother" ED.string)
    (ED.field "company" eetfCompanyDecoder)

jsonEncoder : Person -> JE.Value
jsonEncoder {name, role, nicknames, houses, crimes, father, mother, company} =
  JE.object
    [ ("name", JE.string name)
    , ("role", jsonRoleEncoder role)
    , ("nicknames", JE.list JE.string nicknames)
    , ("houses", JE.list jsonHouseEncoder houses)
    , ("crimes", JE.list jsonCrimeEncoder crimes)
    , ("father", JE.string father)
    , ("mother", JE.string mother)
    , ("company", jsonCompanyEncoder company)
    ]

eetfEncoder : Person -> EE.Value
eetfEncoder {name, role, nicknames, houses, crimes, father, mother, company} =
  EE.object
    [ ("name", EE.string name)
    , ("role", eetfRoleEncoder role)
    , ("nicknames", EE.list EE.string nicknames)
    , ("houses", EE.list eetfHouseEncoder houses)
    , ("crimes", EE.list eetfCrimeEncoder crimes)
    , ("father", EE.string father)
    , ("mother", EE.string mother)
    , ("company", eetfCompanyEncoder company)
    ]

-- Private

-- JSON

jsonCompanyDecoder : JD.Decoder Company
jsonCompanyDecoder =
  JD.map3 Company
    (JD.field "name" JD.string)
    (JD.field "employee_count" JD.int)
    (JD.field "industry" jsonIndustryDecoder)

jsonHouseDecoder : JD.Decoder House
jsonHouseDecoder =
  JD.map2 House
    (JD.field "location" JD.string)
    (JD.field "area" JD.int)

jsonRoleDecoder : JD.Decoder Role
jsonRoleDecoder =
  JD.string
  |> JD.andThen (\str ->
    case str of
      "user" -> JD.succeed User
      "member" -> JD.succeed Member
      "admin" -> JD.succeed Admin
      _ -> JD.fail "Unknown role."
  )

jsonIndustryDecoder : JD.Decoder Industry
jsonIndustryDecoder =
  JD.string
  |> JD.andThen (\str ->
    case str of
      "pharma" -> JD.succeed Pharma
      "tech" -> JD.succeed Tech
      "sports" -> JD.succeed Sports
      "retail" -> JD.succeed Retail
      _ -> JD.fail "Unknown role."
  )

jsonRoleEncoder : Role -> JE.Value
jsonRoleEncoder role =
  case role of
    User -> JE.string "role"
    Member -> JE.string "member"
    Admin -> JE.string "admin"

jsonHouseEncoder : House -> JE.Value
jsonHouseEncoder house =
  JE.object
    [ ("location", JE.string house.location)
    , ("area", JE.int house.area)
    ]

jsonIndustryEncoder : Industry -> JE.Value
jsonIndustryEncoder industry =
  case industry of
    Pharma -> JE.string "pharma"
    Tech -> JE.string "tech"
    Sports -> JE.string "sports"
    Retail -> JE.string "retail"

jsonCrimeEncoder : (String, Int) -> JE.Value
jsonCrimeEncoder (crime, count) =
  JE.object
    [ ("crime", JE.string crime)
    , ("count", JE.int count)
    ]

jsonCompanyEncoder : Company -> JE.Value
jsonCompanyEncoder {name, employeeCount, industry} =
  JE.object
    [ ("name", JE.string name)
    , ("employee_count", JE.int employeeCount)
    , ("industry", jsonIndustryEncoder industry)
    ]

-- EETF

eetfCompanyDecoder : ED.Decoder Company
eetfCompanyDecoder =
  ED.map3 Company
    (ED.field "name" ED.string)
    (ED.field "employee_count" ED.int)
    (ED.field "industry" eetfIndustryDecoder)

eetfHouseDecoder : ED.Decoder House
eetfHouseDecoder =
  ED.map2 House
    (ED.field "location" ED.string)
    (ED.field "area" ED.int)

eetfRoleDecoder : ED.Decoder Role
eetfRoleDecoder =
  ED.string
  |> ED.andThen (\str ->
    case str of
      "user" -> ED.succeed User
      "member" -> ED.succeed Member
      "admin" -> ED.succeed Admin
      _ -> ED.fail "Unknown role."
  )

eetfIndustryDecoder : ED.Decoder Industry
eetfIndustryDecoder =
  ED.string
  |> ED.andThen (\str ->
    case str of
      "pharma" -> ED.succeed Pharma
      "tech" -> ED.succeed Tech
      "sports" -> ED.succeed Sports
      "retail" -> ED.succeed Retail
      _ -> ED.fail "Unknown role."
  )

eetfRoleEncoder : Role -> EE.Value
eetfRoleEncoder role =
  case role of
    User -> EE.string "role"
    Member -> EE.string "member"
    Admin -> EE.string "admin"

eetfHouseEncoder : House -> EE.Value
eetfHouseEncoder house =
  EE.object
    [ ("location", EE.string house.location)
    , ("area", EE.int house.area)
    ]

eetfIndustryEncoder : Industry -> EE.Value
eetfIndustryEncoder industry =
  case industry of
    Pharma -> EE.string "pharma"
    Tech -> EE.string "tech"
    Sports -> EE.string "sports"
    Retail -> EE.string "retail"

eetfCrimeEncoder : (String, Int) -> EE.Value
eetfCrimeEncoder (crime, count) =
  EE.object
    [ ("crime", EE.string crime)
    , ("count", EE.int count)
    ]

eetfCompanyEncoder : Company -> EE.Value
eetfCompanyEncoder {name, employeeCount, industry} =
  EE.object
    [ ("name", EE.string name)
    , ("employee_count", EE.int employeeCount)
    , ("industry", eetfIndustryEncoder industry)
    ]
