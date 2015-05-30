{-# LANGUAGE OverloadedStrings #-}
module Main where


import Control.Applicative
import Data.Conduit as C
import Network.HTTP.Conduit
import System.Environment

import TwitterAuth
import TwitterPipe
import TwitterSources



main :: IO()
main = do
   logInfo <- fromFile =<< head <$> getArgs
   withManager $ \m -> realSource logInfo m $$ tweetPipe "haskell"
   
   
test :: IO()
test = fakeSource $$ tweetPipe "haskell"




