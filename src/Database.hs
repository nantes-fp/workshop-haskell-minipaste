{-#LANGUAGE OverloadedStrings #-}
module Database where

import           Control.Applicative
import           Database.PostgreSQL.Simple
import           Database.PostgreSQL.Simple.FromRow
import Data.Maybe
import Data.UUID

import           Paste

host = undefined
db = undefined
user = undefined
port = undefined
pass = undefined

connInfo :: ConnectInfo
connInfo = ConnectInfo host port user pass db

instance FromRow User where
  fromRow = User <$> field <*> field <*> field <*> field

instance FromRow Paste where
  fromRow = Paste <$> field <*> field <*> field <*> field <*> field

getPaste :: Connection -> UUID -> IO (Maybe Paste)
getPaste conn uid = listToMaybe <$> query conn q (Only uid)
  where q = "select * from paste where paste_id = ?"

getPastes :: Connection -> Maybe String -> IO [Paste]
getPastes conn lang = case lang of
    Just l -> query conn q (Only l)
    Nothing -> query_ conn q'
  where q = "select * from paste where language = ?"
        q' = "select * from paste"

getUser :: Connection -> UUID -> IO (Maybe User)
getUser conn uid = listToMaybe <$> query conn q (Only uid)
  where q = "select * from \"user\" where user_id = ?"
