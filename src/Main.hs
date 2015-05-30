{-# LANGUAGE OverloadedStrings #-}
module Main where


import Control.Applicative
import Control.Monad.IO.Class(liftIO)

import Data.Conduit as C
import qualified Data.Conduit.List as CL

import Network.HTTP.Conduit
import System.Environment
import Web.Twitter.Conduit

import TwitterAuth
import TwitterFilters
import TwitterInfo


main :: IO()
main = do
   logInfo <- fromFile =<< head <$> getArgs
   withManager $ \m -> 
      sourceWithMaxId logInfo m homeTimeline
         $$ CL.map extractInfo
         $= CL.filter (userLike "haskell")
         $= CL.isolate 1
         =$ CL.mapM_ (liftIO . handleTweet)


handleTweet :: TweetInfo -> IO ()
handleTweet = print


