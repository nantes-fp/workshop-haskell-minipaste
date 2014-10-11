{-# LANGUAGE OverloadedStrings #-}
module Paste where

import qualified Data.ByteString as BS
import qualified Data.Text       as T
import           Data.Time.Clock
import           Data.UUID

data User = User { user_id     :: UUID
                 , email       :: T.Text
                 , password    :: BS.ByteString
                 , u_createdAt :: UTCTime
                 }

data Paste = Paste { paste_id      :: UUID
                   , contents      :: T.Text
                   , language      :: T.Text
                   , p_createdAt   :: UTCTime
                   , paste_user_id :: UUID
                   }


