{-# LANGUAGE OverloadedStrings #-}
module TwitterSources (
   realSource,
   fakeSource
) where


import Control.Monad.Trans.Resource
import Data.Conduit as C
import qualified Data.Conduit.List as CL
import Network.HTTP.Conduit
import Web.Twitter.Conduit

import TwitterInfo



realSource :: (MonadResource m) => TWInfo -> Manager -> Source m TweetInfo
realSource logInfo m =
   sourceWithMaxId logInfo m homeTimeline $= CL.map extractInfo


fakeSource :: (Monad m) => [TweetInfo] -> Source m TweetInfo
fakeSource = CL.sourceList
