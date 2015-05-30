{-# LANGUAGE OverloadedStrings #-}
module Main where


-- import Control.Lens
import Control.Applicative
import Control.Monad.IO.Class(liftIO)

import qualified Data.Conduit as C
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
import Web.Twitter.Types

import TwitterAuth



main :: IO()
main = do
   keyFilePath <- head <$> getArgs
   twitterInfo <- fromFile keyFilePath
   timeline <- withManager $ \m -> call twitterInfo m homeTimeline
                                   -- call twitterInfo mgr $ homeTimeline & count ?~ 200
   print timeline


