{-# LANGUAGE OverloadedStrings #-}
module TwitterAuth (fromFile) where


import Data.String
import Web.Authenticate.OAuth
import Web.Twitter.Conduit


fromFile :: FilePath -> IO TWInfo
fromFile p = do
   t <- readFile p
   return $ fromText t


fromText :: String -> TWInfo
fromText t =
   let [k1, k2, k3, k4] = fmap fromString (lines t)
       tokens = twitterOAuth { oauthConsumerKey = k1, oauthConsumerSecret = k2 }
       credential = Credential [ ("oauth_token", k3), ("oauth_token_secret", k4) ]
   in setCredential tokens credential def
