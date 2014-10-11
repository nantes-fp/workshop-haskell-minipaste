{-# LANGUAGE OverloadedStrings #-}
module Paste where

import qualified Data.ByteString as BS
import qualified Data.Text       as T
import qualified Data.Text.Encoding       as T
import           Data.Time.Clock
import           Data.UUID
import           Data.UUID.V4
import Crypto.Scrypt

data User = User { user_id     :: UUID
                 , email       :: T.Text
                 , password    :: BS.ByteString
                 , u_createdAt :: UTCTime
                 } deriving (Show)

data Paste = Paste { paste_id      :: UUID
                   , contents      :: T.Text
                   , language      :: T.Text
                   , p_createdAt   :: UTCTime
                   , paste_user_id :: UUID
                   } deriving (Show)

createPaste :: T.Text -> T.Text -> UUID -> IO Paste
createPaste contents language uid = do
    pid <- nextRandom
    now <- getCurrentTime
    return $ Paste pid contents language now uid

createUser :: T.Text -> T.Text -> IO User
createUser mail pass = do
    uid <- nextRandom
    now <- getCurrentTime
    hash <-  encryptPassIO' (Pass $ T.encodeUtf8 pass)
    return $ User uid mail(getEncryptedPass hash) now

checkUserPassword :: T.Text -> User -> Bool
checkUserPassword pass user = verifyPass' (Pass $ T.encodeUtf8 pass)
                                          (EncryptedPass $ password user)
