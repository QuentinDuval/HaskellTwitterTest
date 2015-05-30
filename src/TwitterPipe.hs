{-# LANGUAGE OverloadedStrings #-}
module TwitterPipe (
   tweetSelect
) where


import Control.Lens
import Data.Conduit as C
import qualified Data.Conduit.List as CL
import Data.List
import Data.Ord
import Data.Text(Text)
import qualified Data.Text as T

import TwitterInfo


tweetSelect :: (Monad m) => Source m TweetInfo -> Text -> Int -> m [TweetInfo]
tweetSelect src filter' count' = do
   res <- src $$ tweetSink filter' count'
   return $ sortBy (comparing (Down . _popularity)) res


tweetSink :: (Monad m) => Text -> Int -> Sink TweetInfo m [TweetInfo]
tweetSink filterCriteria maxCount =
   CL.filter (userLike filterCriteria)
   $= CL.isolate maxCount
   =$ CL.fold (flip (:)) []


userLike :: Text -> TweetInfo -> Bool
userLike name' info =
   let pat = T.toLower name'
   in T.isInfixOf pat $ T.toLower (info ^. author . authorName)


