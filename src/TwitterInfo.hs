{-# LANGUAGE TemplateHaskell #-}
module TwitterInfo where

import Control.Lens
import Data.Text
import Web.Twitter.Types.Lens


data AuthorInfo = AuthorInfo {
   _authorName :: Text,
   _authorPopularity :: Int
} deriving (Show, Eq, Ord, Read)


data TweetInfo = TweetInfo {
   _uniqueId    :: Integer,
   _author      :: AuthorInfo,
   _content     :: Text,
   _popularity  :: Integer
} deriving (Show, Eq, Ord, Read)


makeLenses ''AuthorInfo
makeLenses ''TweetInfo

extractInfo :: Status -> TweetInfo
extractInfo status =
   TweetInfo {
      _uniqueId = status ^. statusId,
      _author = extractUserInfo status,
      _content = status ^. statusText,
      _popularity = status ^. statusRetweetCount + status ^. statusFavoriteCount
   }

extractUserInfo :: Status -> AuthorInfo
extractUserInfo status = AuthorInfo { 
   _authorName = status ^. statusUser . userName,
   _authorPopularity = status ^. statusUser . userFollowersCount + status ^. statusUser . userFriendsCount
}

