{-# LANGUAGE OverloadedStrings #-}
module Main where


import Control.Applicative
import Control.Lens
import Control.Monad.IO.Class(liftIO)

import Data.Conduit as C
import qualified Data.Conduit.List as CL

import Data.Text(Text)
import qualified Data.Text as T
-- import qualified Data.Text.IO as T

import Network.HTTP.Conduit
import System.Environment
import Web.Twitter.Conduit

import TwitterAuth
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


userLike :: Text -> TweetInfo -> Bool
userLike name' info =
   let pat = T.toLower name'
   in T.isInfixOf pat $ T.toLower (info ^. author . authorName)


handleTweet :: TweetInfo -> IO ()
handleTweet = print


