{-# LANGUAGE OverloadedStrings #-}
module Main where


-- import Control.Lens
import Control.Monad.IO.Class(liftIO)

import qualified Data.Conduit as C
import qualified Data.Conduit.List as CL
import qualified Data.Text as T
import qualified Data.Text.IO as T

import Data.List (isInfixOf, or)
import Data.Map((!))
import Data.Text(Text)

import Network.HTTP
import Network.HTTP.Conduit
import Web.Authenticate.OAuth
import Web.Twitter.Conduit
import Web.Twitter.Types



-- DOC
-- http://hackage.haskell.org/package/twitter-conduit-0.1.0/docs/Web-Twitter-Conduit.html#

tokens :: OAuth
tokens = twitterOAuth
    { oauthConsumerKey = "YOUR CONSUMER KEY"
    , oauthConsumerSecret = "YOUR CONSUMER SECRET"
    }

credential :: Credential
credential = Credential
    [ ("oauth_token", "YOUR ACCESS TOKEN")
    , ("oauth_token_secret", "YOUR ACCESS TOKEN SECRET")
    ]

twitterInfo :: TWInfo
twitterInfo = setCredential tokens credential def


main::IO()
main = do
   timeline <- withManager $ \m -> call twitterInfo m homeTimeline
                                   -- call twitterInfo mgr $ homeTimeline & count ?~ 200
   print timeline
   -- analyze "haskell"


{-
analyze :: Text -> IO()
analyze query = runTwitterFromEnv' $ do
   src <- stream $ statusesFilterByTrack query
   src C.$$+- CL.mapM_ (liftIO . process)


process :: StreamingAPI -> IO ()
process = undefined
-}
