module TwitterPipeTest where

import TwitterPipe
import TwitterSources

import Test.Tasty
-- import Test.Tasty.QuickCheck as QC
import Test.Tasty.HUnit


pipeTests :: TestTree
pipeTests = testCase "" $ do
   assertBool "test" (True)



