{-# LANGUAGE OverloadedStrings #-}
module Main where

import           Control.Monad
import           Control.Monad.IO.Class
import           Network.HTTP.Types.Status
import           Data.Monoid
import           Data.Foldable
import           Database.PostgreSQL.Simple
import           Web.Scotty
import qualified Data.UUID as UUID
import qualified Data.Text as T
import qualified Data.Text.Lazy as TL

import           Database
import           Paste

formatPasteLine :: Paste -> T.Text
formatPasteLine (Paste i _ l _ _) = mconcat [
     "<li><a href=\"/pastes/"
   , T.pack $ UUID.toString i
   , "\">"
   , T.pack $ UUID.toString i
   , " ("
   , l
   , ") "
   , "</a></li>"
   ]

formatPaste :: Paste -> T.Text
formatPaste (Paste _ c _ _ _) = c

formatPastes :: [Paste] -> T.Text
formatPastes ps = "<ul>"
                <> foldMap formatPasteLine ps
                <> "</ul>"

main :: IO ()
main = do
    conn <- connect connInfo
    scotty 3000 $ do
        get "/pastes" $ do
            pastes <- liftIO $ getPastes conn Nothing
            html $ TL.fromStrict $ formatPastes pastes
        get "/pastes/:uid" $ do
            u <- param "uid"
            case UUID.fromString u of
                Nothing -> status status404 >> html "<h1>Paste not found</h1>"
                Just uuid -> do
                    paste <- liftIO $ getPaste conn uuid
                    case paste of
                        Just p -> html $ TL.fromStrict $ formatPaste p
                        Nothing -> status status404 >> html "<h1>Paste not found</h1>"

