{-# LANGUAGE OverloadedStrings #-}
module Main where


import Control.Applicative
import Control.Monad.IO.Class
import Control.Monad.Trans.Resource

import Data.Conduit as C
import qualified Data.Conduit.List as CL

import Data.Text(Text)
import Network.HTTP.Conduit
import System.Environment
import Web.Twitter.Conduit

import TwitterAuth
import TwitterFilters
import TwitterInfo



main :: IO()
main = do
   logInfo <- fromFile =<< head <$> getArgs
   withManager $ \m -> realSource logInfo m $$ tweetPipe "haskell"


realSource :: (MonadResource m) => TWInfo -> Manager -> Source m TweetInfo
realSource logInfo m =
   sourceWithMaxId logInfo m homeTimeline $= CL.map extractInfo


tweetPipe :: (MonadIO m) => Text -> Sink TweetInfo m ()
tweetPipe filterCriteria =
    CL.filter (userLike filterCriteria)
    $= CL.isolate 1
    =$ CL.mapM_ (liftIO . handleTweet)


handleTweet :: TweetInfo -> IO ()
handleTweet = print


