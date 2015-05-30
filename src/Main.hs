{-# LANGUAGE OverloadedStrings #-}
module Main where


import Control.Applicative
import Control.Lens
import Control.Monad.IO.Class(liftIO)

import Data.Conduit as C
import qualified Data.Conduit.List as CL

import Data.Text(Text)
import qualified Data.Text as T
import qualified Data.Text.IO as T

import Network.HTTP.Conduit
import System.Environment
import Web.Twitter.Conduit
import Web.Twitter.Types.Lens

import TwitterAuth



main :: IO()
main = do
   logInfo <- fromFile =<< head <$> getArgs
   withManager $ \m -> 
      sourceWithMaxId logInfo m homeTimeline
         $$ CL.filter (filterUser "reddit_haskell")
         $= CL.isolate 10 =$ CL.mapM_ (liftIO . handleTweet)


filterUser :: Text -> Status -> Bool
filterUser name' status =
   status ^. statusUser . userScreenName == name' 


handleTweet :: Status -> IO ()
handleTweet status = T.putStrLn (status ^. statusUser . userScreenName)


