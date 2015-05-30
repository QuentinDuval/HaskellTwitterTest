module TwitterPipe (
   tweetPipe,
   tweetSinkList
) where


import Control.Lens
import Control.Monad.IO.Class
import Data.Conduit as C
import qualified Data.Conduit.List as CL
import Data.Text as T

import TwitterInfo


tweetPipe :: (MonadIO m) => Text -> Sink TweetInfo m ()
tweetPipe filterCriteria =
   CL.filter (userLike filterCriteria)
   $= CL.isolate 1
   =$ CL.mapM_ (liftIO . handleTweet)


tweetSinkList :: (Monad m) => Text -> Sink TweetInfo m [TweetInfo]
tweetSinkList filterCriteria=
   CL.filter (userLike filterCriteria)
   $= CL.isolate 1
   =$ CL.fold (flip (:)) []


userLike :: Text -> TweetInfo -> Bool
userLike name' info =
   let pat = T.toLower name'
   in T.isInfixOf pat $ T.toLower (info ^. author . authorName)


handleTweet :: TweetInfo -> IO ()
handleTweet = print

