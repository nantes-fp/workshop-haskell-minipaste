module Paste.Tests where

import           Data.Functor
import qualified Data.Text               as T
import qualified Test.QuickCheck.Monadic as QCM
import           Test.Tasty
import           Test.Tasty.HUnit
import qualified Test.Tasty.QuickCheck   as QC
import Test.Tasty.QuickCheck (testProperty)

import           Paste

tests :: TestTree
tests = testGroup "Paste.Tests" [
        testProperty "dummy" prop_dummy
    ,   testProperty "create" prop_create
    ,   testCase "dummy unit" test_dummy
    ]

prop_dummy :: String -> Bool
prop_dummy a = reverse (reverse a) == a

prop_create = QCM.monadicIO $ do
    email <- T.pack <$> QCM.pick QC.arbitrary
    password <- T.pack <$> QCM.pick QC.arbitrary
    user <- QCM.run $ createUser email password
    QCM.assert $ (checkUserPassword password user) == True

test_dummy = True @?= False
