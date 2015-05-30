{-# LANGUAGE OverloadedStrings #-}
module TwitterSources (
   realSource,
   fakeSource
) where


import Control.Monad.Trans.Resource
import Data.Conduit as C
import Data.Text
import qualified Data.Conduit.List as CL
import Network.HTTP.Conduit
import Web.Twitter.Conduit

import TwitterInfo



realSource :: (MonadResource m) => TWInfo -> Manager -> Source m TweetInfo
realSource logInfo m =
   sourceWithMaxId logInfo m homeTimeline $= CL.map extractInfo


fakeSource :: (Monad m) => [Text] -> Source m TweetInfo
fakeSource authors = CL.sourceList authors =$ CL.map makeTweet
   where
      makeTweet author' =
         TweetInfo {
            _uniqueId = 1,
            _author = AuthorInfo { _authorName = author', _authorPopularity = 2},
            _content = "Dummy content with link! http://www.google.fr",
            _popularity = 0}

