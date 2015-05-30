module Main where

import Test.Tasty
import TwitterPipeTest


main :: IO()
main = defaultMain tests

tests :: TestTree
tests = testGroup "Tests" [pipeTests]
