{-# LANGUAGE OverloadedStrings #-}
module Main where


import Control.Applicative
import Network.HTTP.Conduit
import System.Environment

import OutputBuilder
import TwitterAuth
import TwitterInfo
import TwitterPipe
import TwitterSources



main :: IO()
main = do
   logInfo <- fromFile =<< head <$> getArgs
   tweets <- withManager $ \m ->
      tweetSelect (realSource logInfo m) "haskell" 50
   buildHtmlFile "out.html" tweets
   
   
test :: IO ()
test = do
   input <- lines <$> readFile "testTweets.txt"
   let tweets = map (read :: String -> TweetInfo) input
   res <- tweetSelect (fakeSource tweets) "haskell" 50
   buildHtmlFile "out.html" res

