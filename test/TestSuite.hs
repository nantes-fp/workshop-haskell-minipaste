module Main where

import Test.Tasty (defaultMain, testGroup)

import qualified Paste.Tests

main :: IO ()
main = defaultMain $ testGroup "Tests"
    [ Paste.Tests.tests
    ]

