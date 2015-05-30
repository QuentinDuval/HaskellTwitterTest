module TwitterFilters where

import Control.Lens
import Data.Text(Text)
import qualified Data.Text as T

import TwitterInfo


userLike :: Text -> TweetInfo -> Bool
userLike name' info =
   let pat = T.toLower name'
   in T.isInfixOf pat $ T.toLower (info ^. author . authorName)

