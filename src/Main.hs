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
   
   
test :: IO()
test = fakeSource $$ tweetPipe "haskell"


realSource :: (MonadResource m) => TWInfo -> Manager -> Source m TweetInfo
realSource logInfo m =
   sourceWithMaxId logInfo m homeTimeline $= CL.map extractInfo


fakeSource :: (Monad m) => Source m TweetInfo
fakeSource = yield
   TweetInfo {
      _uniqueId = 1,
      _author = AuthorInfo { _authorName = "john_doe", _authorPopularity = 2},
      _content = "Dummy content with link! http://www.google.fr",
      _popularity = 0}


tweetPipe :: (MonadIO m) => Text -> Sink TweetInfo m ()
tweetPipe filterCriteria =
    CL.filter (userLike filterCriteria)
    $= CL.isolate 1
    =$ CL.mapM_ (liftIO . handleTweet)


handleTweet :: TweetInfo -> IO ()
handleTweet = print


