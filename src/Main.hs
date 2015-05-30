{-# LANGUAGE OverloadedStrings #-}
module Main where


-- import Control.Lens
import Control.Applicative
import Control.Lens
import Control.Monad.IO.Class(liftIO)

import Data.Conduit as C
import qualified Data.Conduit.List as CL
import qualified Data.Text as T
import qualified Data.Text.IO as T

import Data.List (isInfixOf, or)
import Data.Map((!))
import Data.String
import Data.Text(Text)

import Network.HTTP.Conduit
import System.Environment
import Web.Twitter.Conduit
import Web.Twitter.Types.Lens

import TwitterAuth




main :: IO()
main = do
   keyFilePath <- head <$> getArgs
   twitterInfo <- fromFile keyFilePath
   
   timeline <- withManager $ \m -> 
      sourceWithMaxId twitterInfo m homeTimeline
         $= CL.isolate 60
         $$ CL.mapM_ $ \status ->
            liftIO $ T.putStrLn (status ^. statusUser . userScreenName)
   
   print timeline


