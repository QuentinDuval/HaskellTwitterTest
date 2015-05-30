{-# LANGUAGE OverloadedStrings #-}
module Main where


-- import Control.Lens
import Control.Applicative
import Control.Monad.IO.Class(liftIO)

import qualified Data.ByteString as B
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
import System.IO

import Web.Authenticate.OAuth
import Web.Twitter.Conduit
import Web.Twitter.Types




main :: IO()
main = do
   keyFilePath <- head <$> getArgs
   keys <- lines <$> readFile keyFilePath
   let [k1, k2, k3, k4] = fmap fromString keys
   let tokens = twitterOAuth { oauthConsumerKey = k1, oauthConsumerSecret = k2 }
   let credential = Credential [ ("oauth_token", k3), ("oauth_token_secret", k4) ]
   let twitterInfo = setCredential tokens credential def
   timeline <- withManager $ \m -> call twitterInfo m homeTimeline
                                   -- call twitterInfo mgr $ homeTimeline & count ?~ 200
   print timeline


