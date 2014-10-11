module Paste.Tests where

import           Data.Functor
import qualified Data.Text               as T
import qualified Test.QuickCheck.Monadic as QCM
import           Test.Tasty
import qualified Test.Tasty.QuickCheck   as QC

import           Paste

tests :: TestTree
tests = testGroup "Paste.Tests" [
        QC.testProperty "dummy" prop_dummy
    ,   QC.testProperty "create" prop_create
    ]

prop_dummy :: String -> Bool
prop_dummy a = reverse (reverse a) == a

prop_create = QCM.monadicIO $ do
    email <- T.pack <$> QCM.pick QC.arbitrary
    password <- T.pack <$> QCM.pick QC.arbitrary
    user <- QCM.run $ createUser email password
    QCM.assert $ (checkUserPassword password user) == True
