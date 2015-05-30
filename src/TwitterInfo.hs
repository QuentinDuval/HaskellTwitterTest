{-# LANGUAGE TemplateHaskell #-}
module TwitterInfo where

import Control.Lens
import Data.Text
import Web.Twitter.Types.Lens


data AuthorInfo = AuthorInfo {
   _authorName :: Text,
   _authorPopularity :: Int
} deriving (Show, Eq, Ord)


data TweetInfo = TweetInfo {
   _uniqueId    :: Integer,
   _author      :: AuthorInfo,
   _content     :: Text,
   _popularity  :: Integer
} deriving (Show, Eq, Ord)


makeLenses ''AuthorInfo
makeLenses ''TweetInfo

extractInfo :: Status -> TweetInfo
extractInfo status =
   TweetInfo {
      _uniqueId = status ^. statusId,
      _author = AuthorInfo { 
            _authorName = status ^. statusUser . userName,
            _authorPopularity = status ^. statusUser . userFollowersCount
                              + status ^. statusUser . userFriendsCount
         },
      _content = status ^. statusText,
      _popularity = status ^. statusRetweetCount + status ^. statusFavoriteCount
   }
